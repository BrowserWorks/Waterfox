use super::internal::*;
use super::*;

pub fn fold<U, I, ID, F>(base: I, identity: ID, fold_op: F) -> Fold<I, ID, F>
    where I: ParallelIterator,
          F: Fn(U, I::Item) -> U + Sync + Send,
          ID: Fn() -> U + Sync + Send,
          U: Send
{
    Fold {
        base: base,
        identity: identity,
        fold_op: fold_op,
    }
}

/// `Fold` is an iterator that applies a function over an iterator producing a single value.
/// This struct is created by the [`fold()`] method on [`ParallelIterator`]
///
/// [`fold()`]: trait.ParallelIterator.html#method.fold
/// [`ParallelIterator`]: trait.ParallelIterator.html
#[must_use = "iterator adaptors are lazy and do nothing unless consumed"]
pub struct Fold<I, ID, F> {
    base: I,
    identity: ID,
    fold_op: F,
}

impl<U, I, ID, F> ParallelIterator for Fold<I, ID, F>
    where I: ParallelIterator,
          F: Fn(U, I::Item) -> U + Sync + Send,
          ID: Fn() -> U + Sync + Send,
          U: Send
{
    type Item = U;

    fn drive_unindexed<C>(self, consumer: C) -> C::Result
        where C: UnindexedConsumer<Self::Item>
    {
        let consumer1 = FoldConsumer {
            base: consumer,
            fold_op: &self.fold_op,
            identity: &self.identity,
        };
        self.base.drive_unindexed(consumer1)
    }
}

struct FoldConsumer<'c, C, ID: 'c, F: 'c> {
    base: C,
    fold_op: &'c F,
    identity: &'c ID,
}

impl<'r, U, T, C, ID, F> Consumer<T> for FoldConsumer<'r, C, ID, F>
    where C: Consumer<U>,
          F: Fn(U, T) -> U + Sync,
          ID: Fn() -> U + Sync,
          U: Send
{
    type Folder = FoldFolder<'r, C::Folder, U, F>;
    type Reducer = C::Reducer;
    type Result = C::Result;

    fn split_at(self, index: usize) -> (Self, Self, Self::Reducer) {
        let (left, right, reducer) = self.base.split_at(index);
        (FoldConsumer { base: left, ..self }, FoldConsumer { base: right, ..self }, reducer)
    }

    fn into_folder(self) -> Self::Folder {
        FoldFolder {
            base: self.base.into_folder(),
            item: (self.identity)(),
            fold_op: self.fold_op,
        }
    }

    fn full(&self) -> bool {
        self.base.full()
    }
}

impl<'r, U, T, C, ID, F> UnindexedConsumer<T> for FoldConsumer<'r, C, ID, F>
    where C: UnindexedConsumer<U>,
          F: Fn(U, T) -> U + Sync,
          ID: Fn() -> U + Sync,
          U: Send
{
    fn split_off_left(&self) -> Self {
        FoldConsumer { base: self.base.split_off_left(), ..*self }
    }

    fn to_reducer(&self) -> Self::Reducer {
        self.base.to_reducer()
    }
}

struct FoldFolder<'r, C, ID, F: 'r> {
    base: C,
    fold_op: &'r F,
    item: ID,
}

impl<'r, C, ID, F, T> Folder<T> for FoldFolder<'r, C, ID, F>
    where C: Folder<ID>,
          F: Fn(ID, T) -> ID + Sync
{
    type Result = C::Result;

    fn consume(self, item: T) -> Self {
        let item = (self.fold_op)(self.item, item);
        FoldFolder {
            base: self.base,
            fold_op: self.fold_op,
            item: item,
        }
    }

    fn complete(self) -> C::Result {
        self.base.consume(self.item).complete()
    }

    fn full(&self) -> bool {
        self.base.full()
    }
}

// ///////////////////////////////////////////////////////////////////////////

pub fn fold_with<U, I, F>(base: I, item: U, fold_op: F) -> FoldWith<I, U, F>
    where I: ParallelIterator,
          F: Fn(U, I::Item) -> U + Sync,
          U: Send + Clone
{
    FoldWith {
        base: base,
        item: item,
        fold_op: fold_op,
    }
}

/// `FoldWith` is an iterator that applies a function over an iterator producing a single value.
/// This struct is created by the [`fold_with()`] method on [`ParallelIterator`]
///
/// [`fold_with()`]: trait.ParallelIterator.html#method.fold_with
/// [`ParallelIterator`]: trait.ParallelIterator.html
#[must_use = "iterator adaptors are lazy and do nothing unless consumed"]
pub struct FoldWith<I, U, F> {
    base: I,
    item: U,
    fold_op: F,
}

impl<U, I, F> ParallelIterator for FoldWith<I, U, F>
    where I: ParallelIterator,
          F: Fn(U, I::Item) -> U + Sync + Send,
          U: Send + Clone
{
    type Item = U;

    fn drive_unindexed<C>(self, consumer: C) -> C::Result
        where C: UnindexedConsumer<Self::Item>
    {
        let consumer1 = FoldWithConsumer {
            base: consumer,
            item: self.item,
            fold_op: &self.fold_op,
        };
        self.base.drive_unindexed(consumer1)
    }
}

struct FoldWithConsumer<'c, C, U, F: 'c> {
    base: C,
    item: U,
    fold_op: &'c F,
}

impl<'r, U, T, C, F> Consumer<T> for FoldWithConsumer<'r, C, U, F>
    where C: Consumer<U>,
          F: Fn(U, T) -> U + Sync,
          U: Send + Clone
{
    type Folder = FoldFolder<'r, C::Folder, U, F>;
    type Reducer = C::Reducer;
    type Result = C::Result;

    fn split_at(self, index: usize) -> (Self, Self, Self::Reducer) {
        let (left, right, reducer) = self.base.split_at(index);
        (FoldWithConsumer { base: left, item: self.item.clone(), ..self },
         FoldWithConsumer { base: right, ..self }, reducer)
    }

    fn into_folder(self) -> Self::Folder {
        FoldFolder {
            base: self.base.into_folder(),
            item: self.item,
            fold_op: self.fold_op,
        }
    }

    fn full(&self) -> bool {
        self.base.full()
    }
}

impl<'r, U, T, C, F> UnindexedConsumer<T> for FoldWithConsumer<'r, C, U, F>
    where C: UnindexedConsumer<U>,
          F: Fn(U, T) -> U + Sync,
          U: Send + Clone
{
    fn split_off_left(&self) -> Self {
        FoldWithConsumer { base: self.base.split_off_left(), item: self.item.clone(), ..*self }
    }

    fn to_reducer(&self) -> Self::Reducer {
        self.base.to_reducer()
    }
}
