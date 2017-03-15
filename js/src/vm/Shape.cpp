/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 * vim: set ts=8 sts=4 et sw=4 tw=99:
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* JS symbol tables. */

#include "vm/Shape-inl.h"

#include "mozilla/DebugOnly.h"
#include "mozilla/MathAlgorithms.h"
#include "mozilla/PodOperations.h"

#include "jsatom.h"
#include "jscntxt.h"
#include "jshashutil.h"
#include "jsobj.h"

#include "gc/Policy.h"
#include "js/HashTable.h"

#include "jscntxtinlines.h"
#include "jscompartmentinlines.h"
#include "jsobjinlines.h"

#include "vm/Caches-inl.h"
#include "vm/NativeObject-inl.h"

using namespace js;
using namespace js::gc;

using mozilla::CeilingLog2Size;
using mozilla::DebugOnly;
using mozilla::PodZero;
using mozilla::RotateLeft;

using JS::AutoCheckCannotGC;

Shape* const ShapeTable::Entry::SHAPE_REMOVED = (Shape*)ShapeTable::Entry::SHAPE_COLLISION;

bool
ShapeTable::init(ExclusiveContext* cx, Shape* lastProp)
{
    uint32_t sizeLog2 = CeilingLog2Size(entryCount_);
    uint32_t size = JS_BIT(sizeLog2);
    if (entryCount_ >= size - (size >> 2))
        sizeLog2++;
    if (sizeLog2 < MIN_SIZE_LOG2)
        sizeLog2 = MIN_SIZE_LOG2;

    size = JS_BIT(sizeLog2);
    entries_ = cx->pod_calloc<Entry>(size);
    if (!entries_)
        return false;

    MOZ_ASSERT(sizeLog2 <= HASH_BITS);
    hashShift_ = HASH_BITS - sizeLog2;

    for (Shape::Range<NoGC> r(lastProp); !r.empty(); r.popFront()) {
        Shape& shape = r.front();
        Entry& entry = searchUnchecked<MaybeAdding::Adding>(shape.propid());

        /*
         * Beware duplicate args and arg vs. var conflicts: the youngest shape
         * (nearest to lastProp) must win. See bug 600067.
         */
        if (!entry.shape())
            entry.setPreservingCollision(&shape);
    }

    MOZ_ASSERT(capacity() == size);
    MOZ_ASSERT(size >= MIN_SIZE);
    MOZ_ASSERT(!needsToGrow());
    return true;
}

void
Shape::removeFromDictionary(NativeObject* obj)
{
    MOZ_ASSERT(inDictionary());
    MOZ_ASSERT(obj->inDictionaryMode());
    MOZ_ASSERT(listp);

    MOZ_ASSERT(obj->shape_->inDictionary());
    MOZ_ASSERT(obj->shape_->listp == &obj->shape_);

    if (parent)
        parent->listp = listp;
    *listp = parent;
    listp = nullptr;

    obj->shape_->clearCachedBigEnoughForShapeTable();
}

void
Shape::insertIntoDictionary(GCPtrShape* dictp)
{
    // Don't assert inDictionaryMode() here because we may be called from
    // JSObject::toDictionaryMode via JSObject::newDictionaryShape.
    MOZ_ASSERT(inDictionary());
    MOZ_ASSERT(!listp);

    MOZ_ASSERT_IF(*dictp, (*dictp)->inDictionary());
    MOZ_ASSERT_IF(*dictp, (*dictp)->listp == dictp);
    MOZ_ASSERT_IF(*dictp, zone() == (*dictp)->zone());

    setParent(dictp->get());
    if (parent)
        parent->listp = &parent;
    listp = (GCPtrShape*) dictp;
    *dictp = this;
}

bool
Shape::makeOwnBaseShape(ExclusiveContext* cx)
{
    MOZ_ASSERT(!base()->isOwned());
    MOZ_ASSERT(cx->zone() == zone());

    BaseShape* nbase = Allocate<BaseShape, NoGC>(cx);
    if (!nbase)
        return false;

    new (nbase) BaseShape(StackBaseShape(this));
    nbase->setOwned(base()->toUnowned());

    this->base_ = nbase;

    return true;
}

void
Shape::handoffTableTo(Shape* shape)
{
    MOZ_ASSERT(inDictionary() && shape->inDictionary());

    if (this == shape)
        return;

    MOZ_ASSERT(base()->isOwned() && !shape->base()->isOwned());

    BaseShape* nbase = base();

    MOZ_ASSERT_IF(shape->hasSlot(), nbase->slotSpan() > shape->slot());

    this->base_ = nbase->baseUnowned();
    nbase->adoptUnowned(shape->base()->toUnowned());

    shape->base_ = nbase;
}

/* static */ bool
Shape::hashify(ExclusiveContext* cx, Shape* shape)
{
    MOZ_ASSERT(!shape->hasTable());

    if (!shape->ensureOwnBaseShape(cx))
        return false;

    ShapeTable* table = cx->new_<ShapeTable>(shape->entryCount());
    if (!table)
        return false;

    if (!table->init(cx, shape)) {
        js_free(table);
        return false;
    }

    shape->base()->setTable(table);
    return true;
}

/*
 * Double hashing needs the second hash code to be relatively prime to table
 * size, so we simply make hash2 odd.
 */
static HashNumber
Hash1(HashNumber hash0, uint32_t shift)
{
    return hash0 >> shift;
}

static HashNumber
Hash2(HashNumber hash0, uint32_t log2, uint32_t shift)
{
    return ((hash0 << log2) >> shift) | 1;
}

template<MaybeAdding Adding>
ShapeTable::Entry&
ShapeTable::searchUnchecked(jsid id)
{
    MOZ_ASSERT(entries_);
    MOZ_ASSERT(!JSID_IS_EMPTY(id));

    /* Compute the primary hash address. */
    HashNumber hash0 = HashId(id);
    HashNumber hash1 = Hash1(hash0, hashShift_);
    Entry* entry = &getEntry(hash1);

    /* Miss: return space for a new entry. */
    if (entry->isFree())
        return *entry;

    /* Hit: return entry. */
    Shape* shape = entry->shape();
    if (shape && shape->propidRaw() == id)
        return *entry;

    /* Collision: double hash. */
    uint32_t sizeLog2 = HASH_BITS - hashShift_;
    HashNumber hash2 = Hash2(hash0, sizeLog2, hashShift_);
    uint32_t sizeMask = JS_BITMASK(sizeLog2);

    /* Save the first removed entry pointer so we can recycle it if adding. */
    Entry* firstRemoved;
    if (Adding == MaybeAdding::Adding) {
        if (entry->isRemoved()) {
            firstRemoved = entry;
        } else {
            firstRemoved = nullptr;
            if (!entry->hadCollision())
                entry->flagCollision();
        }
    }

#ifdef DEBUG
    bool collisionFlag = true;
    if (!entry->isRemoved())
        collisionFlag = entry->hadCollision();
#endif

    while (true) {
        hash1 -= hash2;
        hash1 &= sizeMask;
        entry = &getEntry(hash1);

        if (entry->isFree())
            return (Adding == MaybeAdding::Adding && firstRemoved) ? *firstRemoved : *entry;

        shape = entry->shape();
        if (shape && shape->propidRaw() == id) {
            MOZ_ASSERT(collisionFlag);
            return *entry;
        }

        if (Adding == MaybeAdding::Adding) {
            if (entry->isRemoved()) {
                if (!firstRemoved)
                    firstRemoved = entry;
            } else {
                if (!entry->hadCollision())
                    entry->flagCollision();
            }
        }

#ifdef DEBUG
        if (!entry->isRemoved())
            collisionFlag &= entry->hadCollision();
#endif
    }

    MOZ_CRASH("Shape::search failed to find an expected entry.");
}

template ShapeTable::Entry& ShapeTable::searchUnchecked<MaybeAdding::Adding>(jsid id);
template ShapeTable::Entry& ShapeTable::searchUnchecked<MaybeAdding::NotAdding>(jsid id);

bool
ShapeTable::change(ExclusiveContext* cx, int log2Delta)
{
    MOZ_ASSERT(entries_);
    MOZ_ASSERT(-1 <= log2Delta && log2Delta <= 1);

    /*
     * Grow, shrink, or compress by changing this->entries_.
     */
    uint32_t oldLog2 = HASH_BITS - hashShift_;
    uint32_t newLog2 = oldLog2 + log2Delta;
    uint32_t oldSize = JS_BIT(oldLog2);
    uint32_t newSize = JS_BIT(newLog2);
    Entry* newTable = cx->maybe_pod_calloc<Entry>(newSize);
    if (!newTable)
        return false;

    /* Now that we have newTable allocated, update members. */
    MOZ_ASSERT(newLog2 <= HASH_BITS);
    hashShift_ = HASH_BITS - newLog2;
    removedCount_ = 0;
    Entry* oldTable = entries_;
    entries_ = newTable;

    /* Copy only live entries, leaving removed and free ones behind. */
    AutoCheckCannotGC nogc;
    for (Entry* oldEntry = oldTable; oldSize != 0; oldEntry++) {
        if (Shape* shape = oldEntry->shape()) {
            Entry& entry = search<MaybeAdding::Adding>(shape->propid(), nogc);
            MOZ_ASSERT(entry.isFree());
            entry.setShape(shape);
        }
        oldSize--;
    }

    MOZ_ASSERT(capacity() == newSize);

    /* Finally, free the old entries storage. */
    js_free(oldTable);
    return true;
}

bool
ShapeTable::grow(ExclusiveContext* cx)
{
    MOZ_ASSERT(needsToGrow());

    uint32_t size = capacity();
    int delta = removedCount_ < (size >> 2);

    MOZ_ASSERT(entryCount_ + removedCount_ <= size - 1);

    if (!change(cx, delta)) {
        if (entryCount_ + removedCount_ == size - 1) {
            ReportOutOfMemory(cx);
            return false;
        }
    }

    return true;
}

void
ShapeTable::trace(JSTracer* trc)
{
    for (size_t i = 0; i < capacity(); i++) {
        Entry& entry = getEntry(i);
        Shape* shape = entry.shape();
        if (shape) {
            TraceManuallyBarrieredEdge(trc, &shape, "ShapeTable shape");
            if (shape != entry.shape())
                entry.setPreservingCollision(shape);
        }
    }
}

#ifdef JSGC_HASH_TABLE_CHECKS

void
ShapeTable::checkAfterMovingGC()
{
    for (size_t i = 0; i < capacity(); i++) {
        Entry& entry = getEntry(i);
        Shape* shape = entry.shape();
        if (shape)
            CheckGCThingAfterMovingGC(shape);
    }
}

#endif

/* static */ Shape*
Shape::replaceLastProperty(ExclusiveContext* cx, StackBaseShape& base,
                           TaggedProto proto, HandleShape shape)
{
    MOZ_ASSERT(!shape->inDictionary());

    if (!shape->parent) {
        /* Treat as resetting the initial property of the shape hierarchy. */
        AllocKind kind = gc::GetGCObjectKind(shape->numFixedSlots());
        return EmptyShape::getInitialShape(cx, base.clasp, proto, kind,
                                           base.flags & BaseShape::OBJECT_FLAG_MASK);
    }

    UnownedBaseShape* nbase = BaseShape::getUnowned(cx, base);
    if (!nbase)
        return nullptr;

    Rooted<StackShape> child(cx, StackShape(shape));
    child.setBase(nbase);

    return cx->zone()->propertyTree.getChild(cx, shape->parent, child);
}

/*
 * Get or create a property-tree or dictionary child property of |parent|,
 * which must be lastProperty() if inDictionaryMode(), else parent must be
 * one of lastProperty() or lastProperty()->parent.
 */
/* static */ Shape*
NativeObject::getChildPropertyOnDictionary(ExclusiveContext* cx, HandleNativeObject obj,
                                           HandleShape parent, MutableHandle<StackShape> child)
{
    /*
     * Shared properties have no slot, but slot_ will reflect that of parent.
     * Unshared properties allocate a slot here but may lose it due to a
     * JS_ClearScope call.
     */
    if (!child.hasSlot()) {
        child.setSlot(parent->maybeSlot());
    } else {
        if (child.hasMissingSlot()) {
            uint32_t slot;
            if (!allocSlot(cx, obj, &slot))
                return nullptr;
            child.setSlot(slot);
        } else {
            /*
             * Slots can only be allocated out of order on objects in
             * dictionary mode.  Otherwise the child's slot must be after the
             * parent's slot (if it has one), because slot number determines
             * slot span for objects with that shape.  Usually child slot
             * *immediately* follows parent slot, but there may be a slot gap
             * when the object uses some -- but not all -- of its reserved
             * slots to store properties.
             */
            MOZ_ASSERT(obj->inDictionaryMode() ||
                       parent->hasMissingSlot() ||
                       child.slot() == parent->maybeSlot() + 1 ||
                       (parent->maybeSlot() + 1 < JSSLOT_FREE(obj->getClass()) &&
                        child.slot() == JSSLOT_FREE(obj->getClass())));
        }
    }

    RootedShape shape(cx);

    if (obj->inDictionaryMode()) {
        MOZ_ASSERT(parent == obj->lastProperty());
        shape = child.isAccessorShape() ? Allocate<AccessorShape>(cx) : Allocate<Shape>(cx);
        if (!shape)
            return nullptr;
        if (child.hasSlot() && child.slot() >= obj->lastProperty()->base()->slotSpan()) {
            if (!obj->setSlotSpan(cx, child.slot() + 1)) {
                new (shape) Shape(obj->lastProperty()->base()->unowned(), 0);
                return nullptr;
            }
        }
        shape->initDictionaryShape(child, obj->numFixedSlots(), &obj->shape_);
    }

    return shape;
}

/* static */ Shape*
NativeObject::getChildProperty(ExclusiveContext* cx,
                               HandleNativeObject obj, HandleShape parent,
                               MutableHandle<StackShape> child)
{
    Shape* shape = getChildPropertyOnDictionary(cx, obj, parent, child);

    if (!obj->inDictionaryMode()) {
        shape = cx->zone()->propertyTree.getChild(cx, parent, child);
        if (!shape)
            return nullptr;
        //MOZ_ASSERT(shape->parent == parent);
        //MOZ_ASSERT_IF(parent != lastProperty(), parent == lastProperty()->parent);
        if (!obj->setLastProperty(cx, shape))
            return nullptr;
    }

    return shape;
}

bool
js::NativeObject::toDictionaryMode(ExclusiveContext* cx)
{
    MOZ_ASSERT(!inDictionaryMode());
    MOZ_ASSERT(cx->isInsideCurrentCompartment(this));

    uint32_t span = slotSpan();

    Rooted<NativeObject*> self(cx, this);

    // Clone the shapes into a new dictionary list. Don't update the last
    // property of this object until done, otherwise a GC triggered while
    // creating the dictionary will get the wrong slot span for this object.
    RootedShape root(cx);
    RootedShape dictionaryShape(cx);

    RootedShape shape(cx, lastProperty());
    while (shape) {
        MOZ_ASSERT(!shape->inDictionary());

        Shape* dprop = shape->isAccessorShape() ? Allocate<AccessorShape>(cx) : Allocate<Shape>(cx);
        if (!dprop) {
            ReportOutOfMemory(cx);
            return false;
        }

        GCPtrShape* listp = dictionaryShape ? &dictionaryShape->parent : nullptr;
        StackShape child(shape);
        dprop->initDictionaryShape(child, self->numFixedSlots(), listp);

        if (!dictionaryShape)
            root = dprop;

        MOZ_ASSERT(!dprop->hasTable());
        dictionaryShape = dprop;
        shape = shape->previous();
    }

    if (!Shape::hashify(cx, root)) {
        ReportOutOfMemory(cx);
        return false;
    }

    if (IsInsideNursery(self) &&
        !cx->asJSContext()->gc.nursery.queueDictionaryModeObjectToSweep(self))
    {
        ReportOutOfMemory(cx);
        return false;
    }

    MOZ_ASSERT(root->listp == nullptr);
    root->listp = &self->shape_;
    self->shape_ = root;

    MOZ_ASSERT(self->inDictionaryMode());
    root->base()->setSlotSpan(span);

    return true;
}

/* static */ Shape*
NativeObject::addProperty(ExclusiveContext* cx, HandleNativeObject obj, HandleId id,
                          GetterOp getter, SetterOp setter, uint32_t slot, unsigned attrs,
                          unsigned flags, bool allowDictionary)
{
    MOZ_ASSERT(!JSID_IS_VOID(id));
    MOZ_ASSERT(getter != JS_PropertyStub);
    MOZ_ASSERT(setter != JS_StrictPropertyStub);

    bool extensible;
    if (!IsExtensible(cx, obj, &extensible))
        return nullptr;
    if (!extensible) {
        if (cx->isJSContext())
            obj->reportNotExtensible(cx->asJSContext());
        return nullptr;
    }

    AutoKeepShapeTables keep(cx);
    ShapeTable::Entry* entry = nullptr;
    if (obj->inDictionaryMode()) {
        ShapeTable* table = obj->lastProperty()->ensureTableForDictionary(cx, keep);
        if (!table)
            return nullptr;
        entry = &table->search<MaybeAdding::Adding>(id, keep);
    }

    return addPropertyInternal(cx, obj, id, getter, setter, slot, attrs, flags, entry,
                               allowDictionary, keep);
}

static bool
ShouldConvertToDictionary(NativeObject* obj)
{
    /*
     * Use a lower limit if this object is likely a hashmap (SETELEM was used
     * to set properties).
     */
    if (obj->hadElementsAccess())
        return obj->lastProperty()->entryCount() >= PropertyTree::MAX_HEIGHT_WITH_ELEMENTS_ACCESS;
    return obj->lastProperty()->entryCount() >= PropertyTree::MAX_HEIGHT;
}

/* static */ Shape*
NativeObject::addPropertyInternal(ExclusiveContext* cx,
                                  HandleNativeObject obj, HandleId id,
                                  GetterOp getter, SetterOp setter,
                                  uint32_t slot, unsigned attrs,
                                  unsigned flags, ShapeTable::Entry* entry,
                                  bool allowDictionary, const AutoKeepShapeTables& keep)
{
    MOZ_ASSERT_IF(!allowDictionary, !obj->inDictionaryMode());
    MOZ_ASSERT(getter != JS_PropertyStub);
    MOZ_ASSERT(setter != JS_StrictPropertyStub);

    AutoRooterGetterSetter gsRoot(cx, attrs, &getter, &setter);

    /*
     * The code below deals with either converting obj to dictionary mode or
     * growing an object that's already in dictionary mode. Either way,
     * dictionray operations are safe if thread local.
     */
    ShapeTable* table = nullptr;
    if (!obj->inDictionaryMode()) {
        bool stableSlot =
            (slot == SHAPE_INVALID_SLOT) ||
            obj->lastProperty()->hasMissingSlot() ||
            (slot == obj->lastProperty()->maybeSlot() + 1);
        MOZ_ASSERT_IF(!allowDictionary, stableSlot);
        if (allowDictionary &&
            (!stableSlot || ShouldConvertToDictionary(obj)))
        {
            if (!obj->toDictionaryMode(cx))
                return nullptr;
            table = obj->lastProperty()->maybeTable(keep);
            entry = &table->search<MaybeAdding::Adding>(id, keep);
        }
    } else {
        table = obj->lastProperty()->ensureTableForDictionary(cx, keep);
        if (!table)
            return nullptr;
        if (table->needsToGrow()) {
            if (!table->grow(cx))
                return nullptr;
            entry = &table->search<MaybeAdding::Adding>(id, keep);
            MOZ_ASSERT(!entry->shape());
        }
    }

    MOZ_ASSERT(!!table == !!entry);

    /* Find or create a property tree node labeled by our arguments. */
    RootedShape shape(cx);
    {
        RootedShape last(cx, obj->lastProperty());

        uint32_t index;
        bool indexed = IdIsIndex(id, &index);

        Rooted<UnownedBaseShape*> nbase(cx);
        if (!indexed) {
            nbase = last->base()->unowned();
        } else {
            StackBaseShape base(last->base());
            base.flags |= BaseShape::INDEXED;
            nbase = BaseShape::getUnowned(cx, base);
            if (!nbase)
                return nullptr;
        }

        Rooted<StackShape> child(cx, StackShape(nbase, id, slot, attrs, flags));
        child.updateGetterSetter(getter, setter);
        shape = getChildProperty(cx, obj, last, &child);
    }

    if (shape) {
        MOZ_ASSERT(shape == obj->lastProperty());

        if (table) {
            /* Store the tree node pointer in the table entry for id. */
            entry->setPreservingCollision(shape);
            table->incEntryCount();

            /* Pass the table along to the new last property, namely shape. */
            MOZ_ASSERT(shape->parent->maybeTable(keep) == table);
            shape->parent->handoffTableTo(shape);
        }

        obj->checkShapeConsistency();
        return shape;
    }

    obj->checkShapeConsistency();
    return nullptr;
}

Shape*
js::ReshapeForAllocKind(JSContext* cx, Shape* shape, TaggedProto proto,
                                 gc::AllocKind allocKind)
{
    // Compute the number of fixed slots with the new allocation kind.
    size_t nfixed = gc::GetGCKindSlots(allocKind, shape->getObjectClass());

    // Get all the ids in the shape, in order.
    js::AutoIdVector ids(cx);
    {
        for (unsigned i = 0; i < shape->slotSpan(); i++) {
            if (!ids.append(JSID_VOID))
                return nullptr;
        }
        Shape* nshape = shape;
        while (!nshape->isEmptyShape()) {
            ids[nshape->slot()].set(nshape->propid());
            nshape = nshape->previous();
        }
    }

    // Construct the new shape, without updating type information.
    RootedId id(cx);
    RootedShape newShape(cx, EmptyShape::getInitialShape(cx, shape->getObjectClass(),
                                                         proto, nfixed, shape->getObjectFlags()));
    if (!newShape)
        return nullptr;

    for (unsigned i = 0; i < ids.length(); i++) {
        id = ids[i];

        uint32_t index;
        bool indexed = IdIsIndex(id, &index);

        Rooted<UnownedBaseShape*> nbase(cx, newShape->base()->unowned());
        if (indexed) {
            StackBaseShape base(nbase);
            base.flags |= BaseShape::INDEXED;
            nbase = BaseShape::getUnowned(cx, base);
            if (!nbase)
                return nullptr;
        }

        Rooted<StackShape> child(cx, StackShape(nbase, id, i, JSPROP_ENUMERATE, 0));
        newShape = cx->zone()->propertyTree.getChild(cx, newShape, child);
        if (!newShape)
            return nullptr;
    }

    return newShape;
}

/*
 * Check and adjust the new attributes for the shape to make sure that our
 * slot access optimizations are sound. It is responsibility of the callers to
 * enforce all restrictions from ECMA-262 v5 8.12.9 [[DefineOwnProperty]].
 */
static inline bool
CheckCanChangeAttrs(ExclusiveContext* cx, JSObject* obj, Shape* shape, unsigned* attrsp)
{
    if (shape->configurable())
        return true;

    /* A permanent property must stay permanent. */
    *attrsp |= JSPROP_PERMANENT;

    /* Reject attempts to remove a slot from the permanent data property. */
    if (shape->isDataDescriptor() && shape->hasSlot() &&
        (*attrsp & (JSPROP_GETTER | JSPROP_SETTER | JSPROP_SHARED)))
    {
        if (cx->isJSContext())
            obj->reportNotConfigurable(cx->asJSContext(), shape->propid());
        return false;
    }

    return true;
}

/* static */ Shape*
NativeObject::putProperty(ExclusiveContext* cx, HandleNativeObject obj, HandleId id,
                          GetterOp getter, SetterOp setter, uint32_t slot, unsigned attrs,
                          unsigned flags)
{
    MOZ_ASSERT(!JSID_IS_VOID(id));
    MOZ_ASSERT(getter != JS_PropertyStub);
    MOZ_ASSERT(setter != JS_StrictPropertyStub);

#ifdef DEBUG
    if (obj->is<ArrayObject>()) {
        ArrayObject* arr = &obj->as<ArrayObject>();
        uint32_t index;
        if (IdIsIndex(id, &index))
            MOZ_ASSERT(index < arr->length() || arr->lengthIsWritable());
    }
#endif

    AutoRooterGetterSetter gsRoot(cx, attrs, &getter, &setter);

    /*
     * Search for id in order to claim its entry if table has been allocated.
     *
     * Note that we can only try to claim an entry in a table that is thread
     * local. An object may be thread local *without* its shape being thread
     * local. The only thread local objects that *also* have thread local
     * shapes are dictionaries that were allocated/converted thread
     * locally. Only for those objects we can try to claim an entry in its
     * shape table.
     */
    AutoKeepShapeTables keep(cx);
    ShapeTable::Entry* entry;
    RootedShape shape(cx);
    if (!Shape::search<MaybeAdding::Adding>(cx, obj->lastProperty(), id, keep,
                                            shape.address(), &entry))
    {
        return nullptr;
    }

    if (!shape) {
        /*
         * You can't add properties to a non-extensible object, but you can change
         * attributes of properties in such objects.
         */
        bool extensible;

        if (!IsExtensible(cx, obj, &extensible))
            return nullptr;

        if (!extensible) {
            if (cx->isJSContext())
                obj->reportNotExtensible(cx->asJSContext());
            return nullptr;
        }

        return addPropertyInternal(cx, obj, id, getter, setter, slot, attrs, flags,
                                   entry, true, keep);
    }

    /* Property exists: search must have returned a valid entry. */
    MOZ_ASSERT_IF(entry, !entry->isRemoved());

    if (!CheckCanChangeAttrs(cx, obj, shape, &attrs))
        return nullptr;

    /*
     * If the caller wants to allocate a slot, but doesn't care which slot,
     * copy the existing shape's slot into slot so we can match shape, if all
     * other members match.
     */
    bool hadSlot = shape->hasSlot();
    uint32_t oldSlot = shape->maybeSlot();
    if (!(attrs & JSPROP_SHARED) && slot == SHAPE_INVALID_SLOT && hadSlot)
        slot = oldSlot;

    Rooted<UnownedBaseShape*> nbase(cx);
    {
        uint32_t index;
        bool indexed = IdIsIndex(id, &index);
        StackBaseShape base(obj->lastProperty()->base());
        if (indexed)
            base.flags |= BaseShape::INDEXED;
        nbase = BaseShape::getUnowned(cx, base);
        if (!nbase)
            return nullptr;
    }

    /*
     * Now that we've possibly preserved slot, check whether all members match.
     * If so, this is a redundant "put" and we can return without more work.
     */
    if (shape->matchesParamsAfterId(nbase, slot, attrs, flags, getter, setter))
        return shape;

    /*
     * Overwriting a non-last property requires switching to dictionary mode.
     * The shape tree is shared immutable, and we can't removeProperty and then
     * addPropertyInternal because a failure under add would lose data.
     */
    if (shape != obj->lastProperty() && !obj->inDictionaryMode()) {
        if (!obj->toDictionaryMode(cx))
            return nullptr;
        ShapeTable* table = obj->lastProperty()->maybeTable(keep);
        MOZ_ASSERT(table);
        entry = &table->search<MaybeAdding::NotAdding>(shape->propid(), keep);
        shape = entry->shape();
    }

    MOZ_ASSERT_IF(shape->hasSlot() && !(attrs & JSPROP_SHARED), shape->slot() == slot);

    if (obj->inDictionaryMode()) {
        /*
         * Updating some property in a dictionary-mode object. Create a new
         * shape for the existing property, and also generate a new shape for
         * the last property of the dictionary (unless the modified property
         * is also the last property).
         */
        bool updateLast = (shape == obj->lastProperty());
        bool accessorShape = getter || setter || (attrs & (JSPROP_GETTER | JSPROP_SETTER));
        shape = obj->replaceWithNewEquivalentShape(cx, shape, nullptr, accessorShape);
        if (!shape)
            return nullptr;
        if (!updateLast && !obj->generateOwnShape(cx))
            return nullptr;

        /*
         * FIXME bug 593129 -- slot allocation and NativeObject *this must move
         * out of here!
         */
        if (slot == SHAPE_INVALID_SLOT && !(attrs & JSPROP_SHARED)) {
            if (!allocSlot(cx, obj, &slot))
                return nullptr;
        }

        if (updateLast)
            shape->base()->adoptUnowned(nbase);
        else
            shape->base_ = nbase;

        MOZ_ASSERT_IF(attrs & (JSPROP_GETTER | JSPROP_SETTER), attrs & JSPROP_SHARED);

        shape->setSlot(slot);
        shape->attrs = uint8_t(attrs);
        shape->flags = flags | Shape::IN_DICTIONARY | (accessorShape ? Shape::ACCESSOR_SHAPE : 0);
        if (shape->isAccessorShape()) {
            AccessorShape& accShape = shape->asAccessorShape();
            accShape.rawGetter = getter;
            accShape.rawSetter = setter;
            GetterSetterWriteBarrierPost(&accShape);
        } else {
            MOZ_ASSERT(!getter);
            MOZ_ASSERT(!setter);
        }
    } else {
        /*
         * Updating the last property in a non-dictionary-mode object. Find an
         * alternate shared child of the last property's previous shape.
         */
        StackBaseShape base(obj->lastProperty()->base());

        UnownedBaseShape* nbase = BaseShape::getUnowned(cx, base);
        if (!nbase)
            return nullptr;

        MOZ_ASSERT(shape == obj->lastProperty());

        /* Find or create a property tree node labeled by our arguments. */
        Rooted<StackShape> child(cx, StackShape(nbase, id, slot, attrs, flags));
        child.updateGetterSetter(getter, setter);
        RootedShape parent(cx, shape->parent);
        Shape* newShape = getChildProperty(cx, obj, parent, &child);

        if (!newShape) {
            obj->checkShapeConsistency();
            return nullptr;
        }

        shape = newShape;
    }

    /*
     * Can't fail now, so free the previous incarnation's slot if the new shape
     * has no slot. But we do not need to free oldSlot (and must not, as trying
     * to will botch an assertion in JSObject::freeSlot) if the new last
     * property (shape here) has a slotSpan that does not cover it.
     */
    if (hadSlot && !shape->hasSlot()) {
        if (oldSlot < obj->slotSpan())
            obj->freeSlot(cx, oldSlot);
        /* Note: The optimization based on propertyRemovals is only relevant to the main thread. */
        if (cx->isJSContext())
            ++cx->asJSContext()->runtime()->propertyRemovals;
    }

    obj->checkShapeConsistency();

    return shape;
}

/* static */ Shape*
NativeObject::changeProperty(ExclusiveContext* cx, HandleNativeObject obj, HandleShape shape,
                             unsigned attrs, GetterOp getter, SetterOp setter)
{
    MOZ_ASSERT(obj->containsPure(shape));
    MOZ_ASSERT(getter != JS_PropertyStub);
    MOZ_ASSERT(setter != JS_StrictPropertyStub);
    MOZ_ASSERT_IF(attrs & (JSPROP_GETTER | JSPROP_SETTER), attrs & JSPROP_SHARED);

    /* Allow only shared (slotless) => unshared (slotful) transition. */
    MOZ_ASSERT(!((attrs ^ shape->attrs) & JSPROP_SHARED) ||
               !(attrs & JSPROP_SHARED));

    MarkTypePropertyNonData(cx, obj, shape->propid());

    if (!CheckCanChangeAttrs(cx, obj, shape, &attrs))
        return nullptr;

    if (shape->attrs == attrs && shape->getter() == getter && shape->setter() == setter)
        return shape;

    /*
     * Let JSObject::putProperty handle this |overwriting| case, including
     * the conservation of shape->slot (if it's valid). We must not call
     * removeProperty because it will free an allocated shape->slot, and
     * putProperty won't re-allocate it.
     */
    RootedId propid(cx, shape->propid());
    Shape* newShape = putProperty(cx, obj, propid, getter, setter,
                                  shape->maybeSlot(), attrs, shape->flags);

    obj->checkShapeConsistency();
    return newShape;
}

bool
NativeObject::removeProperty(ExclusiveContext* cx, jsid id_)
{
    RootedId id(cx, id_);
    RootedNativeObject self(cx, this);

    AutoKeepShapeTables keep(cx);
    ShapeTable::Entry* entry;
    RootedShape shape(cx);
    if (!Shape::search(cx, lastProperty(), id, keep, shape.address(), &entry))
        return false;

    if (!shape)
        return true;

    /*
     * If shape is not the last property added, or the last property cannot
     * be removed, switch to dictionary mode.
     */
    if (!self->inDictionaryMode() && (shape != self->lastProperty() || !self->canRemoveLastProperty())) {
        if (!self->toDictionaryMode(cx))
            return false;
        ShapeTable* table = self->lastProperty()->maybeTable(keep);
        MOZ_ASSERT(table);
        entry = &table->search<MaybeAdding::NotAdding>(shape->propid(), keep);
        shape = entry->shape();
    }

    /*
     * If in dictionary mode, get a new shape for the last property after the
     * removal. We need a fresh shape for all dictionary deletions, even of
     * the last property. Otherwise, a shape could replay and caches might
     * return deleted DictionaryShapes! See bug 595365. Do this before changing
     * the object or table, so the remaining removal is infallible.
     */
    RootedShape spare(cx);
    if (self->inDictionaryMode()) {
        /* For simplicity, always allocate an accessor shape for now. */
        spare = Allocate<AccessorShape>(cx);
        if (!spare)
            return false;
        new (spare) Shape(shape->base()->unowned(), 0);
        if (shape == self->lastProperty()) {
            /*
             * Get an up to date unowned base shape for the new last property
             * when removing the dictionary's last property. Information in
             * base shapes for non-last properties may be out of sync with the
             * object's state.
             */
            RootedShape previous(cx, self->lastProperty()->parent);
            StackBaseShape base(self->lastProperty()->base());
            BaseShape* nbase = BaseShape::getUnowned(cx, base);
            if (!nbase)
                return false;
            previous->base_ = nbase;
        }
    }

    /* If shape has a slot, free its slot number. */
    if (shape->hasSlot()) {
        self->freeSlot(cx, shape->slot());
        if (cx->isJSContext())
            ++cx->asJSContext()->runtime()->propertyRemovals;
    }

    /*
     * A dictionary-mode object owns mutable, unique shapes on a non-circular
     * doubly linked list, hashed by lastProperty()->table. So we can edit the
     * list and hash in place.
     */
    if (self->inDictionaryMode()) {
        ShapeTable* table = self->lastProperty()->maybeTable(keep);
        MOZ_ASSERT(table);

        if (entry->hadCollision()) {
            entry->setRemoved();
            table->decEntryCount();
            table->incRemovedCount();
        } else {
            entry->setFree();
            table->decEntryCount();

#ifdef DEBUG
            /*
             * Check the consistency of the table but limit the number of
             * checks not to alter significantly the complexity of the
             * delete in debug builds, see bug 534493.
             */
            Shape* aprop = self->lastProperty();
            for (int n = 50; --n >= 0 && aprop->parent; aprop = aprop->parent)
                MOZ_ASSERT_IF(aprop != shape, self->contains(cx, aprop));
#endif
        }

        {
            /* Remove shape from its non-circular doubly linked list. */
            Shape* oldLastProp = self->lastProperty();
            shape->removeFromDictionary(self);

            /* Hand off table from the old to new last property. */
            oldLastProp->handoffTableTo(self->lastProperty());
        }

        /* Generate a new shape for the object, infallibly. */
        JS_ALWAYS_TRUE(self->generateOwnShape(cx, spare));

        /* Consider shrinking table if its load factor is <= .25. */
        uint32_t size = table->capacity();
        if (size > ShapeTable::MIN_SIZE && table->entryCount() <= size >> 2)
            (void) table->change(cx, -1);
    } else {
        /*
         * Non-dictionary-mode shape tables are shared immutables, so all we
         * need do is retract the last property and we'll either get or else
         * lazily make via a later hashify the exact table for the new property
         * lineage.
         */
        MOZ_ASSERT(shape == self->lastProperty());
        self->removeLastProperty(cx);
    }

    self->checkShapeConsistency();
    return true;
}

/* static */ void
NativeObject::clear(ExclusiveContext* cx, HandleNativeObject obj)
{
    Shape* shape = obj->lastProperty();
    MOZ_ASSERT(obj->inDictionaryMode() == shape->inDictionary());

    while (shape->parent) {
        shape = shape->parent;
        MOZ_ASSERT(obj->inDictionaryMode() == shape->inDictionary());
    }
    MOZ_ASSERT(shape->isEmptyShape());

    if (obj->inDictionaryMode())
        shape->listp = &obj->shape_;

    JS_ALWAYS_TRUE(obj->setLastProperty(cx, shape));

    if (cx->isJSContext())
        ++cx->asJSContext()->runtime()->propertyRemovals;
    obj->checkShapeConsistency();
}

/* static */ bool
NativeObject::rollbackProperties(ExclusiveContext* cx, HandleNativeObject obj, uint32_t slotSpan)
{
    /*
     * Remove properties from this object until it has a matching slot span.
     * The object cannot have escaped in a way which would prevent safe
     * removal of the last properties.
     */
    MOZ_ASSERT(!obj->inDictionaryMode() && slotSpan <= obj->slotSpan());
    while (true) {
        if (obj->lastProperty()->isEmptyShape()) {
            MOZ_ASSERT(slotSpan == 0);
            break;
        } else {
            uint32_t slot = obj->lastProperty()->slot();
            if (slot < slotSpan)
                break;
        }
        if (!obj->removeProperty(cx, obj->lastProperty()->propid()))
            return false;
    }

    return true;
}

Shape*
NativeObject::replaceWithNewEquivalentShape(ExclusiveContext* cx, Shape* oldShape, Shape* newShape,
                                            bool accessorShape)
{
    MOZ_ASSERT(cx->isInsideCurrentZone(oldShape));
    MOZ_ASSERT_IF(oldShape != lastProperty(),
                  inDictionaryMode() && lookup(cx, oldShape->propidRef()) == oldShape);

    NativeObject* self = this;

    if (!inDictionaryMode()) {
        RootedNativeObject selfRoot(cx, self);
        RootedShape newRoot(cx, newShape);
        if (!toDictionaryMode(cx))
            return nullptr;
        oldShape = selfRoot->lastProperty();
        self = selfRoot;
        newShape = newRoot;
    }

    if (!newShape) {
        RootedNativeObject selfRoot(cx, self);
        RootedShape oldRoot(cx, oldShape);
        newShape = (oldShape->isAccessorShape() || accessorShape)
                   ? Allocate<AccessorShape>(cx)
                   : Allocate<Shape>(cx);
        if (!newShape)
            return nullptr;
        new (newShape) Shape(oldRoot->base()->unowned(), 0);
        self = selfRoot;
        oldShape = oldRoot;
    }

    AutoCheckCannotGC nogc;
    ShapeTable* table = self->lastProperty()->ensureTableForDictionary(cx, nogc);
    if (!table)
        return nullptr;

    ShapeTable::Entry* entry = oldShape->isEmptyShape()
        ? nullptr
        : &table->search<MaybeAdding::NotAdding>(oldShape->propidRef(), nogc);

    /*
     * Splice the new shape into the same position as the old shape, preserving
     * enumeration order (see bug 601399).
     */
    StackShape nshape(oldShape);
    newShape->initDictionaryShape(nshape, self->numFixedSlots(), oldShape->listp);

    MOZ_ASSERT(newShape->parent == oldShape);
    oldShape->removeFromDictionary(self);

    if (newShape == self->lastProperty())
        oldShape->handoffTableTo(newShape);

    if (entry)
        entry->setPreservingCollision(newShape);
    return newShape;
}

bool
NativeObject::shadowingShapeChange(ExclusiveContext* cx, const Shape& shape)
{
    return generateOwnShape(cx);
}

bool
JSObject::setFlags(ExclusiveContext* cx, BaseShape::Flag flags, GenerateShape generateShape)
{
    if (hasAllFlags(flags))
        return true;

    RootedObject self(cx, this);

    if (isNative() && as<NativeObject>().inDictionaryMode()) {
        if (generateShape == GENERATE_SHAPE && !as<NativeObject>().generateOwnShape(cx))
            return false;
        StackBaseShape base(self->as<NativeObject>().lastProperty());
        base.flags |= flags;
        UnownedBaseShape* nbase = BaseShape::getUnowned(cx, base);
        if (!nbase)
            return false;

        self->as<NativeObject>().lastProperty()->base()->adoptUnowned(nbase);
        return true;
    }

    Shape* existingShape = self->ensureShape(cx);
    if (!existingShape)
        return false;

    Shape* newShape = Shape::setObjectFlags(cx, flags, self->taggedProto(), existingShape);
    if (!newShape)
        return false;

    // The success of the |JSObject::ensureShape| call above means that |self|
    // can be assumed to have a shape.
    self->as<ShapedObject>().setShape(newShape);

    return true;
}

bool
NativeObject::clearFlag(ExclusiveContext* cx, BaseShape::Flag flag)
{
    MOZ_ASSERT(inDictionaryMode());

    RootedNativeObject self(cx, &as<NativeObject>());
    MOZ_ASSERT(self->lastProperty()->getObjectFlags() & flag);

    StackBaseShape base(self->lastProperty());
    base.flags &= ~flag;
    UnownedBaseShape* nbase = BaseShape::getUnowned(cx, base);
    if (!nbase)
        return false;

    self->lastProperty()->base()->adoptUnowned(nbase);
    return true;
}

/* static */ Shape*
Shape::setObjectFlags(ExclusiveContext* cx, BaseShape::Flag flags, TaggedProto proto, Shape* last)
{
    if ((last->getObjectFlags() & flags) == flags)
        return last;

    StackBaseShape base(last);
    base.flags |= flags;

    RootedShape lastRoot(cx, last);
    return replaceLastProperty(cx, base, proto, lastRoot);
}

/* static */ inline HashNumber
StackBaseShape::hash(const Lookup& lookup)
{
    HashNumber hash = lookup.flags;
    hash = RotateLeft(hash, 4) ^ (uintptr_t(lookup.clasp) >> 3);
    return hash;
}

/* static */ inline bool
StackBaseShape::match(ReadBarriered<UnownedBaseShape*> key, const Lookup& lookup)
{
    return key.unbarrieredGet()->flags == lookup.flags &&
           key.unbarrieredGet()->clasp_ == lookup.clasp;
}

inline
BaseShape::BaseShape(const StackBaseShape& base)
  : clasp_(base.clasp),
    flags(base.flags),
    slotSpan_(0),
    unowned_(nullptr),
    table_(nullptr)
{
}

/* static */ void
BaseShape::copyFromUnowned(BaseShape& dest, UnownedBaseShape& src)
{
    dest.clasp_ = src.clasp_;
    dest.slotSpan_ = src.slotSpan_;
    dest.unowned_ = &src;
    dest.flags = src.flags | OWNED_SHAPE;
}

inline void
BaseShape::adoptUnowned(UnownedBaseShape* other)
{
    // This is a base shape owned by a dictionary object, update it to reflect the
    // unowned base shape of a new last property.
    MOZ_ASSERT(isOwned());

    uint32_t span = slotSpan();

    BaseShape::copyFromUnowned(*this, *other);
    setSlotSpan(span);

    assertConsistency();
}

/* static */ UnownedBaseShape*
BaseShape::getUnowned(ExclusiveContext* cx, StackBaseShape& base)
{
    auto& table = cx->zone()->baseShapes;

    if (!table.initialized() && !table.init()) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    auto p = MakeDependentAddPtr(cx, table, base);
    if (p)
        return *p;

    BaseShape* nbase_ = Allocate<BaseShape>(cx);
    if (!nbase_)
        return nullptr;

    new (nbase_) BaseShape(base);

    UnownedBaseShape* nbase = static_cast<UnownedBaseShape*>(nbase_);

    if (!p.add(cx, table, base, nbase))
        return nullptr;

    return nbase;
}

void
BaseShape::assertConsistency()
{
#ifdef DEBUG
    if (isOwned()) {
        UnownedBaseShape* unowned = baseUnowned();
        MOZ_ASSERT(getObjectFlags() == unowned->getObjectFlags());
    }
#endif
}

void
BaseShape::traceChildren(JSTracer* trc)
{
    traceChildrenSkipShapeTable(trc);
    traceShapeTable(trc);
}

void
BaseShape::traceChildrenSkipShapeTable(JSTracer* trc)
{
    if (isOwned())
        TraceEdge(trc, &unowned_, "base");

    assertConsistency();
}

void
BaseShape::traceShapeTable(JSTracer* trc)
{
    AutoCheckCannotGC nogc;
    if (ShapeTable* table = maybeTable(nogc))
        table->trace(trc);
}

#ifdef DEBUG
bool
BaseShape::canSkipMarkingShapeTable(Shape* lastShape)
{
    // Check that every shape in the shape table will be marked by marking
    // |lastShape|.

    AutoCheckCannotGC nogc;
    ShapeTable* table = maybeTable(nogc);
    if (!table)
        return true;

    uint32_t count = 0;
    for (Shape::Range<NoGC> r(lastShape); !r.empty(); r.popFront()) {
        Shape* shape = &r.front();
        ShapeTable::Entry& entry = table->search<MaybeAdding::NotAdding>(shape->propid(), nogc);
        if (entry.isLive())
            count++;
    }

    return count == table->entryCount();
}
#endif

#ifdef JSGC_HASH_TABLE_CHECKS

void
Zone::checkBaseShapeTableAfterMovingGC()
{
    if (!baseShapes.initialized())
        return;

    for (decltype(baseShapes)::Enum e(baseShapes); !e.empty(); e.popFront()) {
        UnownedBaseShape* base = e.front().unbarrieredGet();
        CheckGCThingAfterMovingGC(base);

        BaseShapeSet::Ptr ptr = baseShapes.lookup(base);
        MOZ_RELEASE_ASSERT(ptr.found() && &*ptr == &e.front());
    }
}

#endif // JSGC_HASH_TABLE_CHECKS

void
BaseShape::finalize(FreeOp* fop)
{
    if (table_) {
        fop->delete_(table_);
        table_ = nullptr;
    }
}

inline
InitialShapeEntry::InitialShapeEntry() : shape(nullptr), proto()
{
}

inline
InitialShapeEntry::InitialShapeEntry(Shape* shape, const Lookup::ShapeProto& proto)
  : shape(shape), proto(proto)
{
}

/* static */ inline HashNumber
InitialShapeEntry::hash(const Lookup& lookup)
{
    return (RotateLeft(uintptr_t(lookup.clasp) >> 3, 4) ^ lookup.proto.hashCode()) +
           lookup.nfixed;
}

/* static */ inline bool
InitialShapeEntry::match(const InitialShapeEntry& key, const Lookup& lookup)
{
    const Shape* shape = key.shape.unbarrieredGet();
    return lookup.clasp == shape->getObjectClass()
        && lookup.nfixed == shape->numFixedSlots()
        && lookup.baseFlags == shape->getObjectFlags()
        && lookup.proto.match(key.proto);
}

#ifdef JSGC_HASH_TABLE_CHECKS

void
Zone::checkInitialShapesTableAfterMovingGC()
{
    if (!initialShapes.initialized())
        return;

    /*
     * Assert that the postbarriers have worked and that nothing is left in
     * initialShapes that points into the nursery, and that the hash table
     * entries are discoverable.
     */
    for (decltype(initialShapes)::Enum e(initialShapes); !e.empty(); e.popFront()) {
        InitialShapeEntry entry = e.front();
        JSProtoKey protoKey = entry.proto.key();
        TaggedProto proto = entry.proto.proto().unbarrieredGet();
        Shape* shape = entry.shape.unbarrieredGet();

        CheckGCThingAfterMovingGC(shape);
        if (proto.isObject())
            CheckGCThingAfterMovingGC(proto.toObject());

        using Lookup = InitialShapeEntry::Lookup;
        Lookup lookup(shape->getObjectClass(),
                      Lookup::ShapeProto(protoKey, proto),
                      shape->numFixedSlots(),
                      shape->getObjectFlags());
        InitialShapeSet::Ptr ptr = initialShapes.lookup(lookup);
        MOZ_RELEASE_ASSERT(ptr.found() && &*ptr == &e.front());
    }
}

#endif // JSGC_HASH_TABLE_CHECKS

Shape*
EmptyShape::new_(ExclusiveContext* cx, Handle<UnownedBaseShape*> base, uint32_t nfixed)
{
    Shape* shape = Allocate<Shape>(cx);
    if (!shape) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    new (shape) EmptyShape(base, nfixed);
    return shape;
}

static bool
IsOriginalProto(GlobalObject* global, JSProtoKey key, JSObject& proto)
{
    if (global->getPrototype(key) != ObjectValue(proto))
        return false;

    if (key == JSProto_Object) {
        MOZ_ASSERT(proto.staticPrototypeIsImmutable(),
                   "proto should be Object.prototype, whose prototype is "
                   "immutable");
        MOZ_ASSERT(proto.staticPrototype() == nullptr,
                   "Object.prototype must have null prototype");
        return true;
    }

    // Check that other prototypes still have Object.prototype as proto.
    JSObject* protoProto = proto.staticPrototype();
    if (!protoProto || global->getPrototype(JSProto_Object) != ObjectValue(*protoProto))
        return false;

    MOZ_ASSERT(protoProto->staticPrototypeIsImmutable(),
               "protoProto should be Object.prototype, whose prototype is "
               "immutable");
    MOZ_ASSERT(protoProto->staticPrototype() == nullptr,
               "Object.prototype must have null prototype");
    return true;
}

static JSProtoKey
GetInitialShapeProtoKey(TaggedProto proto, ExclusiveContext* cx)
{
    if (proto.isObject() && proto.toObject()->hasStaticPrototype()) {
        GlobalObject* global = cx->global();
        JSObject& obj = *proto.toObject();
        MOZ_ASSERT(global == &obj.global());

        if (IsOriginalProto(global, JSProto_Object, obj))
            return JSProto_Object;
        if (IsOriginalProto(global, JSProto_Function, obj))
            return JSProto_Function;
        if (IsOriginalProto(global, JSProto_Array, obj))
            return JSProto_Array;
        if (IsOriginalProto(global, JSProto_RegExp, obj))
            return JSProto_RegExp;
    }
    return JSProto_LIMIT;
}

/* static */ Shape*
EmptyShape::getInitialShape(ExclusiveContext* cx, const Class* clasp, TaggedProto proto,
                            size_t nfixed, uint32_t objectFlags)
{
    MOZ_ASSERT_IF(proto.isObject(), cx->isInsideCurrentCompartment(proto.toObject()));

    auto& table = cx->zone()->initialShapes;

    if (!table.initialized() && !table.init()) {
        ReportOutOfMemory(cx);
        return nullptr;
    }

    using Lookup = InitialShapeEntry::Lookup;
    auto protoPointer = MakeDependentAddPtr(cx, table,
                                            Lookup(clasp, Lookup::ShapeProto(proto),
                                                   nfixed, objectFlags));
    if (protoPointer)
        return protoPointer->shape;

    // No entry for this proto. If the proto is one of a few common builtin
    // prototypes, try to do a lookup based on the JSProtoKey, so we can share
    // shapes across globals.
    Rooted<TaggedProto> protoRoot(cx, proto);
    Shape* shape = nullptr;
    bool insertKey = false;
    mozilla::Maybe<DependentAddPtr<decltype(cx->zone()->initialShapes)>> keyPointer;

    JSProtoKey key = GetInitialShapeProtoKey(protoRoot, cx);
    if (key != JSProto_LIMIT) {
        keyPointer.emplace(MakeDependentAddPtr(cx, table,
                                               Lookup(clasp, Lookup::ShapeProto(key),
                                                      nfixed, objectFlags)));
        if (keyPointer.ref()) {
            shape = keyPointer.ref()->shape;
            MOZ_ASSERT(shape);
        } else {
            insertKey = true;
        }
    }

    if (!shape) {
        StackBaseShape base(cx, clasp, objectFlags);
        Rooted<UnownedBaseShape*> nbase(cx, BaseShape::getUnowned(cx, base));
        if (!nbase)
            return nullptr;

        shape = EmptyShape::new_(cx, nbase, nfixed);
        if (!shape)
            return nullptr;
    }

    Lookup::ShapeProto shapeProto(protoRoot);
    Lookup lookup(clasp, shapeProto, nfixed, objectFlags);
    if (!protoPointer.add(cx, table, lookup, InitialShapeEntry(shape, shapeProto)))
        return nullptr;

    // Also add an entry based on the JSProtoKey, if needed.
    if (insertKey) {
        Lookup::ShapeProto shapeProto(key);
        Lookup lookup(clasp, shapeProto, nfixed, objectFlags);
        if (!keyPointer->add(cx, table, lookup, InitialShapeEntry(shape, shapeProto)))
            return nullptr;
    }

    return shape;
}

/* static */ Shape*
EmptyShape::getInitialShape(ExclusiveContext* cx, const Class* clasp, TaggedProto proto,
                            AllocKind kind, uint32_t objectFlags)
{
    return getInitialShape(cx, clasp, proto, GetGCKindSlots(kind, clasp), objectFlags);
}

void
NewObjectCache::invalidateEntriesForShape(JSContext* cx, HandleShape shape, HandleObject proto)
{
    const Class* clasp = shape->getObjectClass();

    gc::AllocKind kind = gc::GetGCObjectKind(shape->numFixedSlots());
    if (CanBeFinalizedInBackground(kind, clasp))
        kind = GetBackgroundAllocKind(kind);

    RootedObjectGroup group(cx, ObjectGroup::defaultNewGroup(cx, clasp, TaggedProto(proto)));
    if (!group) {
        purge();
        cx->recoverFromOutOfMemory();
        return;
    }

    EntryIndex entry;
    for (CompartmentsInZoneIter comp(shape->zone()); !comp.done(); comp.next()) {
        if (GlobalObject* global = comp->unsafeUnbarrieredMaybeGlobal()) {
            if (lookupGlobal(clasp, global, kind, &entry))
                PodZero(&entries[entry]);
        }
    }
    if (!proto->is<GlobalObject>() && lookupProto(clasp, proto, kind, &entry))
        PodZero(&entries[entry]);
    if (lookupGroup(group, kind, &entry))
        PodZero(&entries[entry]);
}

/* static */ void
EmptyShape::insertInitialShape(ExclusiveContext* cx, HandleShape shape, HandleObject proto)
{
    using Lookup = InitialShapeEntry::Lookup;
    Lookup lookup(shape->getObjectClass(), Lookup::ShapeProto(TaggedProto(proto)),
                  shape->numFixedSlots(), shape->getObjectFlags());

    InitialShapeSet::Ptr p = cx->zone()->initialShapes.lookup(lookup);
    MOZ_ASSERT(p);

    InitialShapeEntry& entry = const_cast<InitialShapeEntry&>(*p);

    // The metadata callback can end up causing redundant changes of the initial shape.
    if (entry.shape == shape)
        return;

    // The new shape had better be rooted at the old one.
#ifdef DEBUG
    Shape* nshape = shape;
    while (!nshape->isEmptyShape())
        nshape = nshape->previous();
    MOZ_ASSERT(nshape == entry.shape);
#endif

    entry.shape = ReadBarrieredShape(shape);

    // For certain prototypes -- namely, those of various builtin classes,
    // keyed by JSProtoKey |key| -- there are two entries: one for a lookup
    // via |proto|, and one for a lookup via |key|.  If this is such a
    // prototype, also update the alternate |key|-keyed shape.
    JSProtoKey key = GetInitialShapeProtoKey(TaggedProto(proto), cx);
    if (key != JSProto_LIMIT) {
        Lookup lookup(shape->getObjectClass(), Lookup::ShapeProto(key),
                      shape->numFixedSlots(), shape->getObjectFlags());
        if (InitialShapeSet::Ptr p = cx->zone()->initialShapes.lookup(lookup)) {
            InitialShapeEntry& entry = const_cast<InitialShapeEntry&>(*p);
            if (entry.shape != shape)
                entry.shape = ReadBarrieredShape(shape);
        }
    }

    /*
     * This affects the shape that will be produced by the various NewObject
     * methods, so clear any cache entry referring to the old shape. This is
     * not required for correctness: the NewObject must always check for a
     * nativeEmpty() result and generate the appropriate properties if found.
     * Clearing the cache entry avoids this duplicate regeneration.
     *
     * Clearing is not necessary when this context is running off the main
     * thread, as it will not use the new object cache for allocations.
     */
    if (cx->isJSContext()) {
        JSContext* ncx = cx->asJSContext();
        ncx->caches.newObjectCache.invalidateEntriesForShape(ncx, shape, proto);
    }
}

void
Zone::fixupInitialShapeTable()
{
    if (!initialShapes.initialized())
        return;

    for (decltype(initialShapes)::Enum e(initialShapes); !e.empty(); e.popFront()) {
        // The shape may have been moved, but we can update that in place.
        Shape* shape = e.front().shape.unbarrieredGet();
        if (IsForwarded(shape)) {
            shape = Forwarded(shape);
            e.mutableFront().shape.set(shape);
        }
        shape->updateBaseShapeAfterMovingGC();

        // If the prototype has moved we have to rekey the entry.
        InitialShapeEntry entry = e.front();
        if (entry.proto.proto().isObject() && IsForwarded(entry.proto.proto().toObject())) {
            entry.proto.setProto(TaggedProto(Forwarded(entry.proto.proto().toObject())));
            using Lookup = InitialShapeEntry::Lookup;
            Lookup relookup(shape->getObjectClass(),
                            Lookup::ShapeProto(entry.proto),
                            shape->numFixedSlots(),
                            shape->getObjectFlags());
            e.rekeyFront(relookup, entry);
        }
    }
}

void
AutoRooterGetterSetter::Inner::trace(JSTracer* trc)
{
    if ((attrs & JSPROP_GETTER) && *pgetter)
        TraceRoot(trc, (JSObject**) pgetter, "AutoRooterGetterSetter getter");
    if ((attrs & JSPROP_SETTER) && *psetter)
        TraceRoot(trc, (JSObject**) psetter, "AutoRooterGetterSetter setter");
}

JS::ubi::Node::Size
JS::ubi::Concrete<js::Shape>::size(mozilla::MallocSizeOf mallocSizeOf) const
{
    Size size = js::gc::Arena::thingSize(get().asTenured().getAllocKind());

    AutoCheckCannotGC nogc;
    if (ShapeTable* table = get().maybeTable(nogc))
        size += table->sizeOfIncludingThis(mallocSizeOf);

    if (!get().inDictionary() && get().kids.isHash())
        size += get().kids.toHash()->sizeOfIncludingThis(mallocSizeOf);

    return size;
}

JS::ubi::Node::Size
JS::ubi::Concrete<js::BaseShape>::size(mozilla::MallocSizeOf mallocSizeOf) const
{
    return js::gc::Arena::thingSize(get().asTenured().getAllocKind());
}
