use std::mem;
use std::prelude::v1::*;

use {Async, Poll};
use stream::{Stream, Fuse};

/// An adaptor that chunks up elements in a vector.
///
/// This adaptor will buffer up a list of items in the stream and pass on the
/// vector used for buffering when a specified capacity has been reached. This
/// is created by the `Stream::chunks` method.
#[derive(Debug)]
#[must_use = "streams do nothing unless polled"]
pub struct Chunks<S>
    where S: Stream
{
    items: Vec<S::Item>,
    err: Option<S::Error>,
    stream: Fuse<S>
}

pub fn new<S>(s: S, capacity: usize) -> Chunks<S>
    where S: Stream
{
    assert!(capacity > 0);

    Chunks {
        items: Vec::with_capacity(capacity),
        err: None,
        stream: super::fuse::new(s),
    }
}

// Forwarding impl of Sink from the underlying stream
impl<S> ::sink::Sink for Chunks<S>
    where S: ::sink::Sink + Stream
{
    type SinkItem = S::SinkItem;
    type SinkError = S::SinkError;

    fn start_send(&mut self, item: S::SinkItem) -> ::StartSend<S::SinkItem, S::SinkError> {
        self.stream.start_send(item)
    }

    fn poll_complete(&mut self) -> Poll<(), S::SinkError> {
        self.stream.poll_complete()
    }

    fn close(&mut self) -> Poll<(), S::SinkError> {
        self.stream.close()
    }
}


impl<S> Chunks<S> where S: Stream {
    fn take(&mut self) -> Vec<S::Item> {
        let cap = self.items.capacity();
        mem::replace(&mut self.items, Vec::with_capacity(cap))
    }
}

impl<S> Stream for Chunks<S>
    where S: Stream
{
    type Item = Vec<<S as Stream>::Item>;
    type Error = <S as Stream>::Error;

    fn poll(&mut self) -> Poll<Option<Self::Item>, Self::Error> {
        if let Some(err) = self.err.take() {
            return Err(err)
        }

        let cap = self.items.capacity();
        loop {
            match self.stream.poll() {
                Ok(Async::NotReady) => return Ok(Async::NotReady),

                // Push the item into the buffer and check whether it is full.
                // If so, replace our buffer with a new and empty one and return
                // the full one.
                Ok(Async::Ready(Some(item))) => {
                    self.items.push(item);
                    if self.items.len() >= cap {
                        return Ok(Some(self.take()).into())
                    }
                }

                // Since the underlying stream ran out of values, return what we
                // have buffered, if we have anything.
                Ok(Async::Ready(None)) => {
                    return if self.items.len() > 0 {
                        let full_buf = mem::replace(&mut self.items, Vec::new());
                        Ok(Some(full_buf).into())
                    } else {
                        Ok(Async::Ready(None))
                    }
                }

                // If we've got buffered items be sure to return them first,
                // we'll defer our error for later.
                Err(e) => {
                    if self.items.len() == 0 {
                        return Err(e)
                    } else {
                        self.err = Some(e);
                        return Ok(Some(self.take()).into())
                    }
                }
            }
        }
    }
}
