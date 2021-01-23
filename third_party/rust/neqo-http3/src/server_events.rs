// Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
// http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
// <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
// option. This file may not be copied, modified, or distributed
// except according to those terms.

use crate::connection::Http3State;
use crate::connection_server::Http3ServerHandler;
use crate::{Header, Res};
use neqo_common::{qdebug, qinfo};
use neqo_transport::server::ActiveConnectionRef;
use neqo_transport::{AppError, Connection};

use std::cell::RefCell;
use std::collections::VecDeque;
use std::rc::Rc;

#[derive(Debug, Clone)]
pub struct ClientRequestStream {
    conn: ActiveConnectionRef,
    handler: Rc<RefCell<Http3ServerHandler>>,
    stream_id: u64,
}

impl ::std::fmt::Display for ClientRequestStream {
    fn fmt(&self, f: &mut ::std::fmt::Formatter) -> ::std::fmt::Result {
        let conn: &Connection = &self.conn.borrow();
        write!(
            f,
            "Http3 server conn={:?} stream_id={}",
            conn, self.stream_id
        )
    }
}

impl ClientRequestStream {
    pub fn new(
        conn: ActiveConnectionRef,
        handler: Rc<RefCell<Http3ServerHandler>>,
        stream_id: u64,
    ) -> Self {
        Self {
            conn,
            handler,
            stream_id,
        }
    }
    pub fn set_response(&mut self, headers: &[Header], data: Vec<u8>) -> Res<()> {
        qinfo!([self], "Set new response.");
        self.handler
            .borrow_mut()
            .set_response(self.stream_id, headers, data)
    }

    pub fn stream_stop_sending(&mut self, app_error: AppError) -> Res<()> {
        qdebug!(
            [self],
            "stop sending stream_id:{} error:{}.",
            self.stream_id,
            app_error
        );
        self.conn
            .borrow_mut()
            .stream_stop_sending(self.stream_id, app_error)?;
        Ok(())
    }

    pub fn stream_reset(&mut self, app_error: AppError) -> Res<()> {
        qdebug!([self], "reset error:{}.", app_error);
        self.handler.borrow_mut().stream_reset(
            &mut self.conn.borrow_mut(),
            self.stream_id,
            app_error,
        )
    }
}

#[derive(Debug, Clone)]
pub enum Http3ServerEvent {
    /// Headers are ready.
    Headers {
        request: ClientRequestStream,
        headers: Vec<Header>,
        fin: bool,
    },
    /// Request data is ready.
    Data {
        request: ClientRequestStream,
        data: Vec<u8>,
        fin: bool,
    },
    /// When individual connection change state. It is only used for tests.
    StateChange {
        conn: ActiveConnectionRef,
        state: Http3State,
    },
}

#[derive(Debug, Default, Clone)]
pub struct Http3ServerEvents {
    events: Rc<RefCell<VecDeque<Http3ServerEvent>>>,
}

impl Http3ServerEvents {
    fn insert(&self, event: Http3ServerEvent) {
        self.events.borrow_mut().push_back(event);
    }

    pub fn events(&self) -> impl Iterator<Item = Http3ServerEvent> {
        self.events.replace(VecDeque::new()).into_iter()
    }

    pub fn has_events(&self) -> bool {
        !self.events.borrow().is_empty()
    }

    pub fn next_event(&self) -> Option<Http3ServerEvent> {
        self.events.borrow_mut().pop_front()
    }

    pub fn headers(&self, request: ClientRequestStream, headers: Vec<Header>, fin: bool) {
        self.insert(Http3ServerEvent::Headers {
            request,
            headers,
            fin,
        });
    }

    pub fn connection_state_change(&self, conn: ActiveConnectionRef, state: Http3State) {
        self.insert(Http3ServerEvent::StateChange { conn, state });
    }

    pub fn data(&self, request: ClientRequestStream, data: Vec<u8>, fin: bool) {
        self.insert(Http3ServerEvent::Data { request, data, fin });
    }
}
