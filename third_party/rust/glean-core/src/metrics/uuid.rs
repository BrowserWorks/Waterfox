// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

use uuid::Uuid;

use crate::metrics::Metric;
use crate::metrics::MetricType;
use crate::storage::StorageManager;
use crate::CommonMetricData;
use crate::Glean;

/// An UUID metric.
///
/// Stores UUID v4 (randomly generated) values.
#[derive(Clone, Debug)]
pub struct UuidMetric {
    meta: CommonMetricData,
}

impl MetricType for UuidMetric {
    fn meta(&self) -> &CommonMetricData {
        &self.meta
    }

    fn meta_mut(&mut self) -> &mut CommonMetricData {
        &mut self.meta
    }
}

impl UuidMetric {
    /// Create a new UUID metric
    pub fn new(meta: CommonMetricData) -> Self {
        Self { meta }
    }

    /// Set to the specified value.
    ///
    /// ## Arguments
    ///
    /// * `glean` - The Glean instance this metric belongs to.
    /// * `value` - The UUID to set the metric to.
    pub fn set(&self, glean: &Glean, value: Uuid) {
        if !self.should_record(glean) {
            return;
        }

        let s = value.to_string();
        let value = Metric::Uuid(s);
        glean.storage().record(glean, &self.meta, &value)
    }

    /// Generate a new random UUID and set the metric to it.
    ///
    /// ## Arguments
    ///
    /// * `glean` - The Glean instance this metric belongs to.
    pub fn generate_and_set(&self, storage: &Glean) -> Uuid {
        let uuid = Uuid::new_v4();
        self.set(storage, uuid);
        uuid
    }

    /// Get the stored Uuid value.
    ///
    /// ## Arguments
    ///
    /// * `glean` - the Glean instance this metric belongs to.
    /// * `storage_name` - the storage name to look into.
    ///
    /// ## Return value
    ///
    /// Returns the stored value or `None` if nothing stored.
    pub(crate) fn get_value(&self, glean: &Glean, storage_name: &str) -> Option<Uuid> {
        match StorageManager.snapshot_metric(
            glean.storage(),
            storage_name,
            &self.meta().identifier(glean),
        ) {
            Some(Metric::Uuid(uuid)) => Uuid::parse_str(&uuid).ok(),
            _ => None,
        }
    }

    /// **Test-only API (exported for FFI purposes).**
    ///
    /// Get the currently stored value as a string.
    ///
    /// This doesn't clear the stored value.
    pub fn test_get_value(&self, glean: &Glean, storage_name: &str) -> Option<String> {
        match StorageManager.snapshot_metric(
            glean.storage(),
            storage_name,
            &self.meta.identifier(glean),
        ) {
            Some(Metric::Uuid(s)) => Some(s),
            _ => None,
        }
    }
}
