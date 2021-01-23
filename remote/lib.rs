// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

extern crate failure;
extern crate http;
extern crate libc;
extern crate log;
extern crate nserror;
extern crate nsstring;
extern crate xpcom;

mod error;
mod remote_agent;
mod startup;

pub use crate::error::RemoteAgentError;
pub use crate::remote_agent::{RemoteAgent, RemoteAgentResult, DEFAULT_HOST, DEFAULT_PORT};
