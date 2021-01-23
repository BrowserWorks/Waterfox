use core::fmt;
use core::marker::PhantomData;
use core::pin::Pin;
use futures_core::future::Future;
use futures_core::stream::Stream;
use futures_core::task::{Context, Poll};
use futures_sink::Sink;
use pin_utils::{unsafe_pinned, unsafe_unpinned};

/// Sink for the [`with`](super::SinkExt::with) method.
#[must_use = "sinks do nothing unless polled"]
pub struct With<Si, Item, U, Fut, F> {
    sink: Si,
    f: F,
    state: Option<Fut>,
    _phantom: PhantomData<fn(U) -> Item>,
}

impl<Si, Item, U, Fut, F> Unpin for With<Si, Item, U, Fut, F>
where
    Si: Unpin,
    Fut: Unpin,
{}

impl<Si, Item, U, Fut, F> fmt::Debug for With<Si, Item, U, Fut, F>
where
    Si: fmt::Debug,
    Fut: fmt::Debug,
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("With")
            .field("sink", &self.sink)
            .field("state", &self.state)
            .finish()
    }
}

impl<Si, Item, U, Fut, F> With<Si, Item, U, Fut, F>
where Si: Sink<Item>,
      F: FnMut(U) -> Fut,
      Fut: Future,
{
    unsafe_pinned!(sink: Si);
    unsafe_unpinned!(f: F);
    unsafe_pinned!(state: Option<Fut>);

    pub(super) fn new<E>(sink: Si, f: F) -> Self
        where
            Fut: Future<Output = Result<Item, E>>,
            E: From<Si::Error>,
    {
        With {
            state: None,
            sink,
            f,
            _phantom: PhantomData,
        }
    }
}

// Forwarding impl of Stream from the underlying sink
impl<S, Item, U, Fut, F> Stream for With<S, Item, U, Fut, F>
    where S: Stream + Sink<Item>,
          F: FnMut(U) -> Fut,
          Fut: Future
{
    type Item = S::Item;

    fn poll_next(
        self: Pin<&mut Self>,
        cx: &mut Context<'_>,
    ) -> Poll<Option<S::Item>> {
        self.sink().poll_next(cx)
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        self.sink.size_hint()
    }
}

impl<Si, Item, U, Fut, F, E> With<Si, Item, U, Fut, F>
    where Si: Sink<Item>,
          F: FnMut(U) -> Fut,
          Fut: Future<Output = Result<Item, E>>,
          E: From<Si::Error>,
{
    /// Get a shared reference to the inner sink.
    pub fn get_ref(&self) -> &Si {
        &self.sink
    }

    /// Get a mutable reference to the inner sink.
    pub fn get_mut(&mut self) -> &mut Si {
        &mut self.sink
    }

    /// Get a pinned mutable reference to the inner sink.
    pub fn get_pin_mut(self: Pin<&mut Self>) -> Pin<&mut Si> {
        self.sink()
    }

    /// Consumes this combinator, returning the underlying sink.
    ///
    /// Note that this may discard intermediate state of this combinator, so
    /// care should be taken to avoid losing resources when this is called.
    pub fn into_inner(self) -> Si {
        self.sink
    }

    /// Completes the processing of previous item if any.
    fn poll(
        mut self: Pin<&mut Self>,
        cx: &mut Context<'_>,
    ) -> Poll<Result<(), E>> {
        let item = match self.as_mut().state().as_pin_mut() {
            None => return Poll::Ready(Ok(())),
            Some(fut) => ready!(fut.poll(cx))?,
        };
        self.as_mut().state().set(None);
        self.as_mut().sink().start_send(item)?;
        Poll::Ready(Ok(()))
    }
}

impl<Si, Item, U, Fut, F, E> Sink<U> for With<Si, Item, U, Fut, F>
    where Si: Sink<Item>,
          F: FnMut(U) -> Fut,
          Fut: Future<Output = Result<Item, E>>,
          E: From<Si::Error>,
{
    type Error = E;

    fn poll_ready(
        mut self: Pin<&mut Self>,
        cx: &mut Context<'_>,
    ) -> Poll<Result<(), Self::Error>> {
        ready!(self.as_mut().poll(cx))?;
        ready!(self.as_mut().sink().poll_ready(cx)?);
        Poll::Ready(Ok(()))
    }

    fn start_send(
        mut self: Pin<&mut Self>,
        item: U,
    ) -> Result<(), Self::Error> {
        let future = (self.as_mut().f())(item);
        self.as_mut().state().set(Some(future));
        Ok(())
    }

    fn poll_flush(
        mut self: Pin<&mut Self>,
        cx: &mut Context<'_>,
    ) -> Poll<Result<(), Self::Error>> {
        ready!(self.as_mut().poll(cx))?;
        ready!(self.as_mut().sink().poll_flush(cx))?;
        Poll::Ready(Ok(()))
    }

    fn poll_close(
        mut self: Pin<&mut Self>,
        cx: &mut Context<'_>,
    ) -> Poll<Result<(), Self::Error>> {
        ready!(self.as_mut().poll(cx))?;
        ready!(self.as_mut().sink().poll_close(cx))?;
        Poll::Ready(Ok(()))
    }
}
