/* -*- Mode: C++; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* vim: set ts=8 sts=2 et sw=2 tw=80: */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

/* Implementations of various class and method modifier attributes. */

#ifndef mozilla_Attributes_h
#define mozilla_Attributes_h

#include "mozilla/Compiler.h"

/*
 * MOZ_ALWAYS_INLINE is a macro which expands to tell the compiler that the
 * method decorated with it must be inlined, even if the compiler thinks
 * otherwise.  This is only a (much) stronger version of the inline hint:
 * compilers are not guaranteed to respect it (although they're much more likely
 * to do so).
 *
 * The MOZ_ALWAYS_INLINE_EVEN_DEBUG macro is yet stronger. It tells the
 * compiler to inline even in DEBUG builds. It should be used very rarely.
 */
#if defined(_MSC_VER)
#  define MOZ_ALWAYS_INLINE_EVEN_DEBUG     __forceinline
#elif defined(__GNUC__)
#  define MOZ_ALWAYS_INLINE_EVEN_DEBUG     __attribute__((always_inline)) inline
#else
#  define MOZ_ALWAYS_INLINE_EVEN_DEBUG     inline
#endif

#if !defined(DEBUG)
#  define MOZ_ALWAYS_INLINE     MOZ_ALWAYS_INLINE_EVEN_DEBUG
#elif defined(_MSC_VER) && !defined(__cplusplus)
#  define MOZ_ALWAYS_INLINE     __inline
#else
#  define MOZ_ALWAYS_INLINE     inline
#endif

#if defined(_MSC_VER)
/*
 * g++ requires -std=c++0x or -std=gnu++0x to support C++11 functionality
 * without warnings (functionality used by the macros below).  These modes are
 * detectable by checking whether __GXX_EXPERIMENTAL_CXX0X__ is defined or, more
 * standardly, by checking whether __cplusplus has a C++11 or greater value.
 * Current versions of g++ do not correctly set __cplusplus, so we check both
 * for forward compatibility.
 */
#  define MOZ_HAVE_NEVER_INLINE          __declspec(noinline)
#  define MOZ_HAVE_NORETURN              __declspec(noreturn)
#elif defined(__clang__)
   /*
    * Per Clang documentation, "Note that marketing version numbers should not
    * be used to check for language features, as different vendors use different
    * numbering schemes. Instead, use the feature checking macros."
    */
#  ifndef __has_extension
#    define __has_extension __has_feature /* compatibility, for older versions of clang */
#  endif
#  if __has_attribute(noinline)
#    define MOZ_HAVE_NEVER_INLINE        __attribute__((noinline))
#  endif
#  if __has_attribute(noreturn)
#    define MOZ_HAVE_NORETURN            __attribute__((noreturn))
#  endif
#elif defined(__GNUC__)
#  define MOZ_HAVE_NEVER_INLINE          __attribute__((noinline))
#  define MOZ_HAVE_NORETURN              __attribute__((noreturn))
#endif

/*
 * When built with clang analyzer (a.k.a scan-build), define MOZ_HAVE_NORETURN
 * to mark some false positives
 */
#ifdef __clang_analyzer__
#  if __has_extension(attribute_analyzer_noreturn)
#    define MOZ_HAVE_ANALYZER_NORETURN __attribute__((analyzer_noreturn))
#  endif
#endif

/*
 * MOZ_NEVER_INLINE is a macro which expands to tell the compiler that the
 * method decorated with it must never be inlined, even if the compiler would
 * otherwise choose to inline the method.  Compilers aren't absolutely
 * guaranteed to support this, but most do.
 */
#if defined(MOZ_HAVE_NEVER_INLINE)
#  define MOZ_NEVER_INLINE      MOZ_HAVE_NEVER_INLINE
#else
#  define MOZ_NEVER_INLINE      /* no support */
#endif

/*
 * MOZ_NORETURN, specified at the start of a function declaration, indicates
 * that the given function does not return.  (The function definition does not
 * need to be annotated.)
 *
 *   MOZ_NORETURN void abort(const char* msg);
 *
 * This modifier permits the compiler to optimize code assuming a call to such a
 * function will never return.  It also enables the compiler to avoid spurious
 * warnings about not initializing variables, or about any other seemingly-dodgy
 * operations performed after the function returns.
 *
 * This modifier does not affect the corresponding function's linking behavior.
 */
#if defined(MOZ_HAVE_NORETURN)
#  define MOZ_NORETURN          MOZ_HAVE_NORETURN
#else
#  define MOZ_NORETURN          /* no support */
#endif

/**
 * MOZ_COLD tells the compiler that a function is "cold", meaning infrequently
 * executed. This may lead it to optimize for size more aggressively than speed,
 * or to allocate the body of the function in a distant part of the text segment
 * to help keep it from taking up unnecessary icache when it isn't in use.
 *
 * Place this attribute at the very beginning of a function definition. For
 * example, write
 *
 *   MOZ_COLD int foo();
 *
 * or
 *
 *   MOZ_COLD int foo() { return 42; }
 */
#if defined(__GNUC__) || defined(__clang__)
#  define MOZ_COLD __attribute__ ((cold))
#else
#  define MOZ_COLD
#endif

/**
 * MOZ_NONNULL tells the compiler that some of the arguments to a function are
 * known to be non-null. The arguments are a list of 1-based argument indexes
 * identifying arguments which are known to be non-null.
 *
 * Place this attribute at the very beginning of a function definition. For
 * example, write
 *
 *   MOZ_NONNULL(1, 2) int foo(char *p, char *q);
 */
#if defined(__GNUC__) || defined(__clang__)
#  define MOZ_NONNULL(...) __attribute__ ((nonnull(__VA_ARGS__)))
#else
#  define MOZ_NONNULL(...)
#endif

/*
 * MOZ_PRETEND_NORETURN_FOR_STATIC_ANALYSIS, specified at the end of a function
 * declaration, indicates that for the purposes of static analysis, this
 * function does not return.  (The function definition does not need to be
 * annotated.)
 *
 * MOZ_ReportCrash(const char* s, const char* file, int ln)
 *   MOZ_PRETEND_NORETURN_FOR_STATIC_ANALYSIS
 *
 * Some static analyzers, like scan-build from clang, can use this information
 * to eliminate false positives.  From the upstream documentation of scan-build:
 * "This attribute is useful for annotating assertion handlers that actually
 * can return, but for the purpose of using the analyzer we want to pretend
 * that such functions do not return."
 *
 */
#if defined(MOZ_HAVE_ANALYZER_NORETURN)
#  define MOZ_PRETEND_NORETURN_FOR_STATIC_ANALYSIS          MOZ_HAVE_ANALYZER_NORETURN
#else
#  define MOZ_PRETEND_NORETURN_FOR_STATIC_ANALYSIS          /* no support */
#endif

/*
 * MOZ_ASAN_BLACKLIST is a macro to tell AddressSanitizer (a compile-time
 * instrumentation shipped with Clang and GCC) to not instrument the annotated
 * function. Furthermore, it will prevent the compiler from inlining the
 * function because inlining currently breaks the blacklisting mechanism of
 * AddressSanitizer.
 */
#if defined(__has_feature)
#  if __has_feature(address_sanitizer)
#    define MOZ_HAVE_ASAN_BLACKLIST
#  endif
#elif defined(__GNUC__)
#  if defined(__SANITIZE_ADDRESS__)
#    define MOZ_HAVE_ASAN_BLACKLIST
#  endif
#endif

#if defined(MOZ_HAVE_ASAN_BLACKLIST)
#  define MOZ_ASAN_BLACKLIST MOZ_NEVER_INLINE __attribute__((no_sanitize_address))
#else
#  define MOZ_ASAN_BLACKLIST /* nothing */
#endif

/*
 * MOZ_TSAN_BLACKLIST is a macro to tell ThreadSanitizer (a compile-time
 * instrumentation shipped with Clang) to not instrument the annotated function.
 * Furthermore, it will prevent the compiler from inlining the function because
 * inlining currently breaks the blacklisting mechanism of ThreadSanitizer.
 */
#if defined(__has_feature)
#  if __has_feature(thread_sanitizer)
#    define MOZ_TSAN_BLACKLIST MOZ_NEVER_INLINE __attribute__((no_sanitize_thread))
#  else
#    define MOZ_TSAN_BLACKLIST /* nothing */
#  endif
#else
#  define MOZ_TSAN_BLACKLIST /* nothing */
#endif

/**
 * MOZ_ALLOCATOR tells the compiler that the function it marks returns either a
 * "fresh", "pointer-free" block of memory, or nullptr. "Fresh" means that the
 * block is not pointed to by any other reachable pointer in the program.
 * "Pointer-free" means that the block contains no pointers to any valid object
 * in the program. It may be initialized with other (non-pointer) values.
 *
 * Placing this attribute on appropriate functions helps GCC analyze pointer
 * aliasing more accurately in their callers.
 *
 * GCC warns if a caller ignores the value returned by a function marked with
 * MOZ_ALLOCATOR: it is hard to imagine cases where dropping the value returned
 * by a function that meets the criteria above would be intentional.
 *
 * Place this attribute after the argument list and 'this' qualifiers of a
 * function definition. For example, write
 *
 *   void *my_allocator(size_t) MOZ_ALLOCATOR;
 *
 * or
 *
 *   void *my_allocator(size_t bytes) MOZ_ALLOCATOR { ... }
 */
#if defined(__GNUC__) || defined(__clang__)
#  define MOZ_ALLOCATOR __attribute__ ((malloc, warn_unused_result))
#else
#  define MOZ_ALLOCATOR
#endif

/**
 * MOZ_MUST_USE tells the compiler to emit a warning if a function's
 * return value is not used by the caller.
 *
 * Place this attribute at the very beginning of a function declaration. For
 * example, write
 *
 *   MOZ_MUST_USE int foo();
 *
 * or
 *
 *   MOZ_MUST_USE int foo() { return 42; }
 */
#if defined(__GNUC__) || defined(__clang__)
#  define MOZ_MUST_USE __attribute__ ((warn_unused_result))
#else
#  define MOZ_MUST_USE
#endif

/**
 * MOZ_FALLTHROUGH is an annotation to suppress compiler warnings about switch
 * cases that fall through without a break or return statement. MOZ_FALLTHROUGH
 * is only needed on cases that have code.
 *
 * MOZ_FALLTHROUGH_ASSERT is an annotation to suppress compiler warnings about
 * switch cases that MOZ_ASSERT(false) (or its alias MOZ_ASSERT_UNREACHABLE) in
 * debug builds, but intentionally fall through in release builds. See comment
 * in Assertions.h for more details.
 *
 * switch (foo) {
 *   case 1: // These cases have no code. No fallthrough annotations are needed.
 *   case 2:
 *   case 3: // This case has code, so a fallthrough annotation is needed!
 *     foo++;
 *     MOZ_FALLTHROUGH;
 *   case 4:
 *     return foo;
 *
 *   default:
 *     // This case asserts in debug builds, falls through in release.
 *     MOZ_FALLTHROUGH_ASSERT("Unexpected foo value?!");
 *   case 5:
 *     return 5;
 * }
 */
#if defined(__clang__) && __cplusplus >= 201103L
   /* clang's fallthrough annotations are only available starting in C++11. */
#  define MOZ_FALLTHROUGH [[clang::fallthrough]]
#elif defined(_MSC_VER)
   /*
    * MSVC's __fallthrough annotations are checked by /analyze (Code Analysis):
    * https://msdn.microsoft.com/en-us/library/ms235402%28VS.80%29.aspx
    */
#  include <sal.h>
#  define MOZ_FALLTHROUGH __fallthrough
#else
#  define MOZ_FALLTHROUGH /* FALLTHROUGH */
#endif

#ifdef __cplusplus

/*
 * The following macros are attributes that support the static analysis plugin
 * included with Mozilla, and will be implemented (when such support is enabled)
 * as C++11 attributes. Since such attributes are legal pretty much everywhere
 * and have subtly different semantics depending on their placement, the
 * following is a guide on where to place the attributes.
 *
 * Attributes that apply to a struct or class precede the name of the class:
 * (Note that this is different from the placement of final for classes!)
 *
 *   class MOZ_CLASS_ATTRIBUTE SomeClass {};
 *
 * Attributes that apply to functions follow the parentheses and const
 * qualifiers but precede final, override and the function body:
 *
 *   void DeclaredFunction() MOZ_FUNCTION_ATTRIBUTE;
 *   void SomeFunction() MOZ_FUNCTION_ATTRIBUTE {}
 *   void PureFunction() const MOZ_FUNCTION_ATTRIBUTE = 0;
 *   void OverriddenFunction() MOZ_FUNCTION_ATTIRBUTE override;
 *
 * Attributes that apply to variables or parameters follow the variable's name:
 *
 *   int variable MOZ_VARIABLE_ATTRIBUTE;
 *
 * Attributes that apply to types follow the type name:
 *
 *   typedef int MOZ_TYPE_ATTRIBUTE MagicInt;
 *   int MOZ_TYPE_ATTRIBUTE someVariable;
 *   int* MOZ_TYPE_ATTRIBUTE magicPtrInt;
 *   int MOZ_TYPE_ATTRIBUTE* ptrToMagicInt;
 *
 * Attributes that apply to statements precede the statement:
 *
 *   MOZ_IF_ATTRIBUTE if (x == 0)
 *   MOZ_DO_ATTRIBUTE do { } while (0);
 *
 * Attributes that apply to labels precede the label:
 *
 *   MOZ_LABEL_ATTRIBUTE target:
 *     goto target;
 *   MOZ_CASE_ATTRIBUTE case 5:
 *   MOZ_DEFAULT_ATTRIBUTE default:
 *
 * The static analyses that are performed by the plugin are as follows:
 *
 * MOZ_MUST_OVERRIDE: Applies to all C++ member functions. All immediate
 *   subclasses must provide an exact override of this method; if a subclass
 *   does not override this method, the compiler will emit an error. This
 *   attribute is not limited to virtual methods, so if it is applied to a
 *   nonvirtual method and the subclass does not provide an equivalent
 *   definition, the compiler will emit an error.
 * MOZ_STACK_CLASS: Applies to all classes. Any class with this annotation is
 *   expected to live on the stack, so it is a compile-time error to use it, or
 *   an array of such objects, as a global or static variable, or as the type of
 *   a new expression (unless placement new is being used). If a member of
 *   another class uses this class, or if another class inherits from this
 *   class, then it is considered to be a stack class as well, although this
 *   attribute need not be provided in such cases.
 * MOZ_NONHEAP_CLASS: Applies to all classes. Any class with this annotation is
 *   expected to live on the stack or in static storage, so it is a compile-time
 *   error to use it, or an array of such objects, as the type of a new
 *   expression. If a member of another class uses this class, or if another
 *   class inherits from this class, then it is considered to be a non-heap class
 *   as well, although this attribute need not be provided in such cases.
 * MOZ_HEAP_CLASS: Applies to all classes. Any class with this annotation is
 *   expected to live on the heap, so it is a compile-time error to use it, or
 *   an array of such objects, as the type of a variable declaration, or as a
 *   temporary object. If a member of another class uses this class, or if
 *   another class inherits from this class, then it is considered to be a heap
 *   class as well, although this attribute need not be provided in such cases.
 * MOZ_NON_TEMPORARY_CLASS: Applies to all classes. Any class with this
 *   annotation is expected not to live in a temporary. If a member of another
 *   class uses this class or if another class inherits from this class, then it
 *   is considered to be a non-temporary class as well, although this attribute
 *   need not be provided in such cases.
 * MOZ_RAII: Applies to all classes. Any class with this annotation is assumed
 *   to be a RAII guard, which is expected to live on the stack in an automatic
 *   allocation. It is prohibited from being allocated in a temporary, static
 *   storage, or on the heap. This is a combination of MOZ_STACK_CLASS and
 *   MOZ_NON_TEMPORARY_CLASS.
 * MOZ_ONLY_USED_TO_AVOID_STATIC_CONSTRUCTORS: Applies to all classes that are
 *   intended to prevent introducing static initializers.  This attribute
 *   currently makes it a compile-time error to instantiate these classes
 *   anywhere other than at the global scope, or as a static member of a class.
 *   In non-debug mode, it also prohibits non-trivial constructors and
 *   destructors.
 * MOZ_TRIVIAL_CTOR_DTOR: Applies to all classes that must have both a trivial
 *   or constexpr constructor and a trivial destructor. Setting this attribute
 *   on a class makes it a compile-time error for that class to get a
 *   non-trivial constructor or destructor for any reason.
 * MOZ_HEAP_ALLOCATOR: Applies to any function. This indicates that the return
 *   value is allocated on the heap, and will as a result check such allocations
 *   during MOZ_STACK_CLASS and MOZ_NONHEAP_CLASS annotation checking.
 * MOZ_IMPLICIT: Applies to constructors. Implicit conversion constructors
 *   are disallowed by default unless they are marked as MOZ_IMPLICIT. This
 *   attribute must be used for constructors which intend to provide implicit
 *   conversions.
 * MOZ_NO_ARITHMETIC_EXPR_IN_ARGUMENT: Applies to functions. Makes it a compile
 *   time error to pass arithmetic expressions on variables to the function.
 * MOZ_OWNING_REF: Applies to declarations of pointers to reference counted
 *   types.  This attribute tells the compiler that the raw pointer is a strong
 *   reference, where ownership through methods such as AddRef and Release is
 *   managed manually.  This can make the compiler ignore these pointers when
 *   validating the usage of pointers otherwise.
 *
 *   Example uses include owned pointers inside of unions, and pointers stored
 *   in POD types where a using a smart pointer class would make the object
 *   non-POD.
 * MOZ_NON_OWNING_REF: Applies to declarations of pointers to reference counted
 *   types.  This attribute tells the compiler that the raw pointer is a weak
 *   reference, which is ensured to be valid by a guarantee that the reference
 *   will be nulled before the pointer becomes invalid.  This can make the compiler
 *   ignore these pointers when validating the usage of pointers otherwise.
 *
 *   Examples include an mOwner pointer, which is nulled by the owning class's
 *   destructor, and is null-checked before dereferencing.
 * MOZ_UNSAFE_REF: Applies to declarations of pointers to reference counted types.
 *   Occasionally there are non-owning references which are valid, but do not take
 *   the form of a MOZ_NON_OWNING_REF.  Their safety may be dependent on the behaviour
 *   of API consumers.  The string argument passed to this macro documents the safety
 *   conditions.  This can make the compiler ignore these pointers when validating
 *   the usage of pointers elsewhere.
 *
 *   Examples include an nsIAtom* member which is known at compile time to point to a
 *   static atom which is valid throughout the lifetime of the program, or an API which
 *   stores a pointer, but doesn't take ownership over it, instead requiring the API
 *   consumer to correctly null the value before it becomes invalid.
 *
 *   Use of this annotation is discouraged when a strong reference or one of the above
 *   two annotations can be used instead.
 * MOZ_NO_ADDREF_RELEASE_ON_RETURN: Applies to function declarations.  Makes it
 *   a compile time error to call AddRef or Release on the return value of a
 *   function.  This is intended to be used with operator->() of our smart
 *   pointer classes to ensure that the refcount of an object wrapped in a
 *   smart pointer is not manipulated directly.
 * MOZ_MUST_USE_TYPE: Applies to type declarations.  Makes it a compile time
 *   error to not use the return value of a function which has this type.  This
 *   is intended to be used with types which it is an error to not use.
 * MOZ_NEEDS_NO_VTABLE_TYPE: Applies to template class declarations.  Makes it
 *   a compile time error to instantiate this template with a type parameter which
 *   has a VTable.
 * MOZ_NON_MEMMOVABLE: Applies to class declarations for types that are not safe
 *   to be moved in memory using memmove().
 * MOZ_NEEDS_MEMMOVABLE_TYPE: Applies to template class declarations where the
 *   template arguments are required to be safe to move in memory using
 *   memmove().  Passing MOZ_NON_MEMMOVABLE types to these templates is a
 *   compile time error.
 * MOZ_NEEDS_MEMMOVABLE_MEMBERS: Applies to class declarations where each member
 *   must be safe to move in memory using memmove().  MOZ_NON_MEMMOVABLE types
 *   used in members of these classes are compile time errors.
 * MOZ_INHERIT_TYPE_ANNOTATIONS_FROM_TEMPLATE_ARGS: Applies to template class
 *   declarations where an instance of the template should be considered, for
 *   static analysis purposes, to inherit any type annotations (such as
 *   MOZ_MUST_USE_TYPE and MOZ_STACK_CLASS) from its template arguments.
 * MOZ_INIT_OUTSIDE_CTOR: Applies to class member declarations. Occasionally
 *   there are class members that are not initialized in the constructor,
 *   but logic elsewhere in the class ensures they are initialized prior to use.
 *   Using this attribute on a member disables the check that this member must be
 *   initialized in constructors via list-initialization, in the constructor body,
 *   or via functions called from the constructor body.
 * MOZ_IS_CLASS_INIT: Applies to class method declarations. Occasionally the
 *   constructor doesn't initialize all of the member variables and another function
 *   is used to initialize the rest. This marker is used to make the static analysis
 *   tool aware that the marked function is part of the initialization process
 *   and to include the marked function in the scan mechanism that determines witch
 *   member variables still remain uninitialized.
 * MOZ_NON_PARAM: Applies to types. Makes it compile time error to use the type
 *   in parameter without pointer or reference.
 * MOZ_NON_AUTOABLE: Applies to class declarations. Makes it a compile time error to
 *   use `auto` in place of this type in variable declarations.  This is intended to
 *   be used with types which are intended to be implicitly constructed into other
 *   other types before being assigned to variables.
 * MOZ_REQUIRED_BASE_METHOD: Applies to virtual class method declarations.
 *  Sometimes derived classes override methods that need to be called by their
 *  overridden counterparts. This marker indicates that the marked method must
 *  be called by the method that it overrides.
 */
#ifdef MOZ_CLANG_PLUGIN
#  define MOZ_MUST_OVERRIDE __attribute__((annotate("moz_must_override")))
#  define MOZ_STACK_CLASS __attribute__((annotate("moz_stack_class")))
#  define MOZ_NONHEAP_CLASS __attribute__((annotate("moz_nonheap_class")))
#  define MOZ_HEAP_CLASS __attribute__((annotate("moz_heap_class")))
#  define MOZ_NON_TEMPORARY_CLASS __attribute__((annotate("moz_non_temporary_class")))
#  define MOZ_TRIVIAL_CTOR_DTOR __attribute__((annotate("moz_trivial_ctor_dtor")))
#  ifdef DEBUG
     /* in debug builds, these classes do have non-trivial constructors. */
#    define MOZ_ONLY_USED_TO_AVOID_STATIC_CONSTRUCTORS __attribute__((annotate("moz_global_class")))
#  else
#    define MOZ_ONLY_USED_TO_AVOID_STATIC_CONSTRUCTORS __attribute__((annotate("moz_global_class"))) \
            MOZ_TRIVIAL_CTOR_DTOR
#  endif
#  define MOZ_IMPLICIT __attribute__((annotate("moz_implicit")))
#  define MOZ_NO_ARITHMETIC_EXPR_IN_ARGUMENT __attribute__((annotate("moz_no_arith_expr_in_arg")))
#  define MOZ_OWNING_REF __attribute__((annotate("moz_strong_ref")))
#  define MOZ_NON_OWNING_REF __attribute__((annotate("moz_weak_ref")))
#  define MOZ_UNSAFE_REF(reason) __attribute__((annotate("moz_weak_ref")))
#  define MOZ_NO_ADDREF_RELEASE_ON_RETURN __attribute__((annotate("moz_no_addref_release_on_return")))
#  define MOZ_MUST_USE_TYPE __attribute__((annotate("moz_must_use_type")))
#  define MOZ_NEEDS_NO_VTABLE_TYPE __attribute__((annotate("moz_needs_no_vtable_type")))
#  define MOZ_NON_MEMMOVABLE __attribute__((annotate("moz_non_memmovable")))
#  define MOZ_NEEDS_MEMMOVABLE_TYPE __attribute__((annotate("moz_needs_memmovable_type")))
#  define MOZ_NEEDS_MEMMOVABLE_MEMBERS __attribute__((annotate("moz_needs_memmovable_members")))
#  define MOZ_INHERIT_TYPE_ANNOTATIONS_FROM_TEMPLATE_ARGS \
    __attribute__((annotate("moz_inherit_type_annotations_from_template_args")))
#  define MOZ_NON_AUTOABLE __attribute__((annotate("moz_non_autoable")))
#  define MOZ_INIT_OUTSIDE_CTOR \
    __attribute__((annotate("moz_ignore_ctor_initialization")))
#  define MOZ_IS_CLASS_INIT \
    __attribute__((annotate("moz_is_class_init")))
#  define MOZ_NON_PARAM \
    __attribute__((annotate("moz_non_param")))
#  define MOZ_REQUIRED_BASE_METHOD \
    __attribute__((annotate("moz_required_base_method")))
/*
 * It turns out that clang doesn't like void func() __attribute__ {} without a
 * warning, so use pragmas to disable the warning. This code won't work on GCC
 * anyways, so the warning is safe to ignore.
 */
#  define MOZ_HEAP_ALLOCATOR \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wgcc-compat\"") \
    __attribute__((annotate("moz_heap_allocator"))) \
    _Pragma("clang diagnostic pop")
#else
#  define MOZ_MUST_OVERRIDE /* nothing */
#  define MOZ_STACK_CLASS /* nothing */
#  define MOZ_NONHEAP_CLASS /* nothing */
#  define MOZ_HEAP_CLASS /* nothing */
#  define MOZ_NON_TEMPORARY_CLASS /* nothing */
#  define MOZ_TRIVIAL_CTOR_DTOR /* nothing */
#  define MOZ_ONLY_USED_TO_AVOID_STATIC_CONSTRUCTORS /* nothing */
#  define MOZ_IMPLICIT /* nothing */
#  define MOZ_NO_ARITHMETIC_EXPR_IN_ARGUMENT /* nothing */
#  define MOZ_HEAP_ALLOCATOR /* nothing */
#  define MOZ_OWNING_REF /* nothing */
#  define MOZ_NON_OWNING_REF /* nothing */
#  define MOZ_UNSAFE_REF(reason) /* nothing */
#  define MOZ_NO_ADDREF_RELEASE_ON_RETURN /* nothing */
#  define MOZ_MUST_USE_TYPE /* nothing */
#  define MOZ_NEEDS_NO_VTABLE_TYPE /* nothing */
#  define MOZ_NON_MEMMOVABLE /* nothing */
#  define MOZ_NEEDS_MEMMOVABLE_TYPE /* nothing */
#  define MOZ_NEEDS_MEMMOVABLE_MEMBERS /* nothing */
#  define MOZ_INHERIT_TYPE_ANNOTATIONS_FROM_TEMPLATE_ARGS /* nothing */
#  define MOZ_INIT_OUTSIDE_CTOR /* nothing */
#  define MOZ_IS_CLASS_INIT /* nothing */
#  define MOZ_NON_PARAM /* nothing */
#  define MOZ_NON_AUTOABLE /* nothing */
#  define MOZ_REQUIRED_BASE_METHOD /* nothing */
#endif /* MOZ_CLANG_PLUGIN */

#define MOZ_RAII MOZ_NON_TEMPORARY_CLASS MOZ_STACK_CLASS

/*
 * MOZ_HAVE_REF_QUALIFIERS is defined for compilers that support C++11's rvalue
 * qualifier, "&&".
 */
#if defined(_MSC_VER) && _MSC_VER >= 1900
#  define MOZ_HAVE_REF_QUALIFIERS
#elif defined(__clang__)
// All supported Clang versions
#  define MOZ_HAVE_REF_QUALIFIERS
#elif defined(__GNUC__)
#  include "mozilla/Compiler.h"
#  if MOZ_GCC_VERSION_AT_LEAST(4, 8, 1)
#    define MOZ_HAVE_REF_QUALIFIERS
#  endif
#endif

#endif /* __cplusplus */

/**
 * Printf style formats.  MOZ_FORMAT_PRINTF can be used to annotate a
 * function or method that is "printf-like"; this will let (some)
 * compilers check that the arguments match the template string.
 *
 * This macro takes two arguments.  The first argument is the argument
 * number of the template string.  The second argument is the argument
 * number of the '...' argument holding the arguments.
 *
 * Argument numbers start at 1.  Note that the implicit "this"
 * argument of a non-static member function counts as an argument.
 *
 * So, for a simple case like:
 *   void print_something (int whatever, const char *fmt, ...);
 * The corresponding annotation would be
 *   MOZ_FORMAT_PRINTF(2, 3)
 * However, if "print_something" were a non-static member function,
 * then the annotation would be:
 *   MOZ_FORMAT_PRINTF(3, 4)
 *
 * Note that the checking is limited to standards-conforming
 * printf-likes, and in particular this should not be used for
 * PR_snprintf and friends, which are "printf-like" but which assign
 * different meanings to the various formats.
 */
#ifdef __GNUC__
#define MOZ_FORMAT_PRINTF(stringIndex, firstToCheck)  \
    __attribute__ ((format (printf, stringIndex, firstToCheck)))
#else
#define MOZ_FORMAT_PRINTF(stringIndex, firstToCheck)
#endif

#endif /* mozilla_Attributes_h */
