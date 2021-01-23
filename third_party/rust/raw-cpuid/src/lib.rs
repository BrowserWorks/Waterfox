#![no_std]
#![crate_name = "raw_cpuid"]
#![crate_type = "lib"]

#[cfg(test)]
#[macro_use]
extern crate std;

#[cfg(test)]
mod tests;
#[cfg(feature = "serialize")]
#[macro_use]
extern crate serde_derive;

#[macro_use]
extern crate bitflags;

/// Provides `cpuid` on stable by linking against a C implementation.
#[cfg(not(feature = "use_arch"))]
pub mod native_cpuid {
    use super::CpuIdResult;

    extern "C" {
        fn cpuid(a: *mut u32, b: *mut u32, c: *mut u32, d: *mut u32);
    }

    pub fn cpuid_count(mut eax: u32, mut ecx: u32) -> CpuIdResult {
        let mut ebx = 0u32;
        let mut edx = 0u32;

        unsafe {
            cpuid(&mut eax, &mut ebx, &mut ecx, &mut edx);
        }

        CpuIdResult { eax, ebx, ecx, edx }
    }
}

/// Uses Rust's `cpuid` function from the `arch` module.
#[cfg(feature = "use_arch")]
pub mod native_cpuid {
    use super::CpuIdResult;

    #[cfg(target_arch = "x86")]
    use core::arch::x86 as arch;
    #[cfg(target_arch = "x86_64")]
    use core::arch::x86_64 as arch;

    pub fn cpuid_count(a: u32, c: u32) -> CpuIdResult {
        let result = unsafe { self::arch::__cpuid_count(a, c) };

        CpuIdResult {
            eax: result.eax,
            ebx: result.ebx,
            ecx: result.ecx,
            edx: result.edx,
        }
    }
}

use core::cmp::min;
use core::fmt;
use core::mem::transmute;
use core::slice;
use core::str;

#[cfg(not(test))]
mod std {
    pub use core::ops;
    pub use core::option;
}

/// Macro which queries cpuid directly.
///
/// First parameter is cpuid leaf (EAX register value),
/// second optional parameter is the subleaf (ECX register value).
#[macro_export]
macro_rules! cpuid {
    ($eax:expr) => {
        $crate::native_cpuid::cpuid_count($eax as u32, 0)
    };

    ($eax:expr, $ecx:expr) => {
        $crate::native_cpuid::cpuid_count($eax as u32, $ecx as u32)
    };
}

fn as_bytes(v: &u32) -> &[u8] {
    let start = v as *const u32 as *const u8;
    unsafe { slice::from_raw_parts(start, 4) }
}

fn get_bits(r: u32, from: u32, to: u32) -> u32 {
    assert!(from <= 31);
    assert!(to <= 31);
    assert!(from <= to);

    let mask = match to {
        31 => 0xffffffff,
        _ => (1 << (to + 1)) - 1,
    };

    (r & mask) >> from
}

macro_rules! check_flag {
    ($doc:meta, $fun:ident, $flags:ident, $flag:expr) => (
        #[$doc]
        pub fn $fun(&self) -> bool {
            self.$flags.contains($flag)
        }
    )
}

macro_rules! is_bit_set {
    ($field:expr, $bit:expr) => {
        $field & (1 << $bit) > 0
    };
}

macro_rules! check_bit_fn {
    ($doc:meta, $fun:ident, $field:ident, $bit:expr) => (
        #[$doc]
        pub fn $fun(&self) -> bool {
            is_bit_set!(self.$field, $bit)
        }
    )
}

/// Main type used to query for information about the CPU we're running on.
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct CpuId {
    max_eax_value: u32,
}

/// Low-level data-structure to store result of cpuid instruction.
#[derive(Copy, Clone, Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct CpuIdResult {
    /// Return value EAX register
    pub eax: u32,
    /// Return value EBX register
    pub ebx: u32,
    /// Return value ECX register
    pub ecx: u32,
    /// Return value EDX register
    pub edx: u32,
}

const EAX_VENDOR_INFO: u32 = 0x0;
const EAX_FEATURE_INFO: u32 = 0x1;
const EAX_CACHE_INFO: u32 = 0x2;
const EAX_PROCESSOR_SERIAL: u32 = 0x3;
const EAX_CACHE_PARAMETERS: u32 = 0x4;
const EAX_MONITOR_MWAIT_INFO: u32 = 0x5;
const EAX_THERMAL_POWER_INFO: u32 = 0x6;
const EAX_STRUCTURED_EXTENDED_FEATURE_INFO: u32 = 0x7;
const EAX_DIRECT_CACHE_ACCESS_INFO: u32 = 0x9;
const EAX_PERFORMANCE_MONITOR_INFO: u32 = 0xA;
const EAX_EXTENDED_TOPOLOGY_INFO: u32 = 0xB;
const EAX_EXTENDED_STATE_INFO: u32 = 0xD;
const EAX_RDT_MONITORING: u32 = 0xF;
const EAX_RDT_ALLOCATION: u32 = 0x10;
const EAX_SGX: u32 = 0x12;
const EAX_TRACE_INFO: u32 = 0x14;
const EAX_TIME_STAMP_COUNTER_INFO: u32 = 0x15;
const EAX_FREQUENCY_INFO: u32 = 0x16;
const EAX_SOC_VENDOR_INFO: u32 = 0x17;
const EAX_DETERMINISTIC_ADDRESS_TRANSLATION_INFO: u32 = 0x18;
const EAX_HYPERVISOR_INFO: u32 = 0x40000000;
const EAX_EXTENDED_FUNCTION_INFO: u32 = 0x80000000;
const EAX_MEMORY_ENCRYPTION_INFO: u32 = 0x8000001F;

impl CpuId {
    /// Return new CPUID struct.
    pub fn new() -> CpuId {
        let res = cpuid!(EAX_VENDOR_INFO);
        CpuId {
            max_eax_value: res.eax,
        }
    }

    fn leaf_is_supported(&self, val: u32) -> bool {
        val <= self.max_eax_value
    }

    /// Return information about vendor.
    /// This is typically a ASCII readable string such as
    /// GenuineIntel for Intel CPUs or AuthenticAMD for AMD CPUs.
    pub fn get_vendor_info(&self) -> Option<VendorInfo> {
        if self.leaf_is_supported(EAX_VENDOR_INFO) {
            let res = cpuid!(EAX_VENDOR_INFO);
            Some(VendorInfo {
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Query a set of features that are available on this CPU.
    pub fn get_feature_info(&self) -> Option<FeatureInfo> {
        if self.leaf_is_supported(EAX_FEATURE_INFO) {
            let res = cpuid!(EAX_FEATURE_INFO);
            Some(FeatureInfo {
                eax: res.eax,
                ebx: res.ebx,
                edx_ecx: FeatureInfoFlags {
                    bits: (((res.edx as u64) << 32) | (res.ecx as u64)),
                },
            })
        } else {
            None
        }
    }

    /// Query basic information about caches. This will just return an index
    /// into a static table of cache descriptions (see `CACHE_INFO_TABLE`).
    pub fn get_cache_info(&self) -> Option<CacheInfoIter> {
        if self.leaf_is_supported(EAX_CACHE_INFO) {
            let res = cpuid!(EAX_CACHE_INFO);
            Some(CacheInfoIter {
                current: 1,
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Retrieve serial number of processor.
    pub fn get_processor_serial(&self) -> Option<ProcessorSerial> {
        if self.leaf_is_supported(EAX_PROCESSOR_SERIAL) {
            let res = cpuid!(EAX_PROCESSOR_SERIAL);
            Some(ProcessorSerial {
                ecx: res.ecx,
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Retrieve more elaborate information about caches (as opposed
    /// to `get_cache_info`). This will tell us about associativity,
    /// set size, line size etc. for each level of the cache hierarchy.
    pub fn get_cache_parameters(&self) -> Option<CacheParametersIter> {
        if self.leaf_is_supported(EAX_CACHE_PARAMETERS) {
            Some(CacheParametersIter { current: 0 })
        } else {
            None
        }
    }

    /// Information about how monitor/mwait works on this CPU.
    pub fn get_monitor_mwait_info(&self) -> Option<MonitorMwaitInfo> {
        if self.leaf_is_supported(EAX_MONITOR_MWAIT_INFO) {
            let res = cpuid!(EAX_MONITOR_MWAIT_INFO);
            Some(MonitorMwaitInfo {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Query information about thermal and power management features of the CPU.
    pub fn get_thermal_power_info(&self) -> Option<ThermalPowerInfo> {
        if self.leaf_is_supported(EAX_THERMAL_POWER_INFO) {
            let res = cpuid!(EAX_THERMAL_POWER_INFO);
            Some(ThermalPowerInfo {
                eax: ThermalPowerFeaturesEax { bits: res.eax },
                ebx: res.ebx,
                ecx: ThermalPowerFeaturesEcx { bits: res.ecx },
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Find out about more features supported by this CPU.
    pub fn get_extended_feature_info(&self) -> Option<ExtendedFeatures> {
        if self.leaf_is_supported(EAX_STRUCTURED_EXTENDED_FEATURE_INFO) {
            let res = cpuid!(EAX_STRUCTURED_EXTENDED_FEATURE_INFO);
            assert!(res.eax == 0);
            Some(ExtendedFeatures {
                eax: res.eax,
                ebx: ExtendedFeaturesEbx { bits: res.ebx },
                ecx: ExtendedFeaturesEcx { bits: res.ecx },
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Direct cache access info.
    pub fn get_direct_cache_access_info(&self) -> Option<DirectCacheAccessInfo> {
        if self.leaf_is_supported(EAX_DIRECT_CACHE_ACCESS_INFO) {
            let res = cpuid!(EAX_DIRECT_CACHE_ACCESS_INFO);
            Some(DirectCacheAccessInfo { eax: res.eax })
        } else {
            None
        }
    }

    /// Info about performance monitoring (how many counters etc.).
    pub fn get_performance_monitoring_info(&self) -> Option<PerformanceMonitoringInfo> {
        if self.leaf_is_supported(EAX_PERFORMANCE_MONITOR_INFO) {
            let res = cpuid!(EAX_PERFORMANCE_MONITOR_INFO);
            Some(PerformanceMonitoringInfo {
                eax: res.eax,
                ebx: PerformanceMonitoringFeaturesEbx { bits: res.ebx },
                ecx: res.ecx,
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Information about topology (how many cores and what kind of cores).
    pub fn get_extended_topology_info(&self) -> Option<ExtendedTopologyIter> {
        if self.leaf_is_supported(EAX_EXTENDED_TOPOLOGY_INFO) {
            Some(ExtendedTopologyIter { level: 0 })
        } else {
            None
        }
    }

    /// Information for saving/restoring extended register state.
    pub fn get_extended_state_info(&self) -> Option<ExtendedStateInfo> {
        if self.leaf_is_supported(EAX_EXTENDED_STATE_INFO) {
            let res = cpuid!(EAX_EXTENDED_STATE_INFO, 0);
            let res1 = cpuid!(EAX_EXTENDED_STATE_INFO, 1);
            Some(ExtendedStateInfo {
                eax: ExtendedStateInfoXCR0Flags { bits: res.eax },
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
                eax1: res1.eax,
                ebx1: res1.ebx,
                ecx1: ExtendedStateInfoXSSFlags { bits: res1.ecx },
                edx1: res1.edx,
            })
        } else {
            None
        }
    }

    /// Quality of service informations.
    pub fn get_rdt_monitoring_info(&self) -> Option<RdtMonitoringInfo> {
        let res = cpuid!(EAX_RDT_MONITORING, 0);

        if self.leaf_is_supported(EAX_RDT_MONITORING) {
            Some(RdtMonitoringInfo {
                ebx: res.ebx,
                edx: res.edx,
            })
        } else {
            None
        }
    }

    /// Quality of service enforcement information.
    pub fn get_rdt_allocation_info(&self) -> Option<RdtAllocationInfo> {
        let res = cpuid!(EAX_RDT_ALLOCATION, 0);

        if self.leaf_is_supported(EAX_RDT_ALLOCATION) {
            Some(RdtAllocationInfo { ebx: res.ebx })
        } else {
            None
        }
    }

    pub fn get_sgx_info(&self) -> Option<SgxInfo> {
        // Leaf 12H sub-leaf 0 (ECX = 0) is supported if CPUID.(EAX=07H, ECX=0H):EBX[SGX] = 1.
        self.get_extended_feature_info().and_then(|info| {
            if self.leaf_is_supported(EAX_SGX) && info.has_sgx() {
                let res = cpuid!(EAX_SGX, 0);
                let res1 = cpuid!(EAX_SGX, 1);
                Some(SgxInfo {
                    eax: res.eax,
                    ebx: res.ebx,
                    ecx: res.ecx,
                    edx: res.edx,
                    eax1: res1.eax,
                    ebx1: res1.ebx,
                    ecx1: res1.ecx,
                    edx1: res1.edx,
                })
            } else {
                None
            }
        })
    }

    /// Intel Processor Trace Enumeration Information.
    pub fn get_processor_trace_info(&self) -> Option<ProcessorTraceInfo> {
        let res = cpuid!(EAX_TRACE_INFO, 0);
        if self.leaf_is_supported(EAX_TRACE_INFO) {
            let res1 = if res.eax >= 1 {
                Some(cpuid!(EAX_TRACE_INFO, 1))
            } else {
                None
            };

            Some(ProcessorTraceInfo {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
                leaf1: res1,
            })
        } else {
            None
        }
    }

    /// Time Stamp Counter/Core Crystal Clock Information.
    pub fn get_tsc_info(&self) -> Option<TscInfo> {
        let res = cpuid!(EAX_TIME_STAMP_COUNTER_INFO, 0);
        if self.leaf_is_supported(EAX_TIME_STAMP_COUNTER_INFO) {
            Some(TscInfo {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
            })
        } else {
            None
        }
    }

    /// Processor Frequency Information.
    pub fn get_processor_frequency_info(&self) -> Option<ProcessorFrequencyInfo> {
        let res = cpuid!(EAX_FREQUENCY_INFO, 0);
        if self.leaf_is_supported(EAX_FREQUENCY_INFO) {
            Some(ProcessorFrequencyInfo {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
            })
        } else {
            None
        }
    }

    pub fn deterministic_address_translation_info(&self) -> Option<DatIter> {
        if self.leaf_is_supported(EAX_DETERMINISTIC_ADDRESS_TRANSLATION_INFO) {
            let res = cpuid!(EAX_DETERMINISTIC_ADDRESS_TRANSLATION_INFO, 0);
            Some(DatIter {
                current: 0,
                count: res.eax,
            })
        } else {
            None
        }
    }

    pub fn get_soc_vendor_info(&self) -> Option<SoCVendorInfo> {
        let res = cpuid!(EAX_SOC_VENDOR_INFO, 0);
        if self.leaf_is_supported(EAX_SOC_VENDOR_INFO) {
            Some(SoCVendorInfo {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            })
        } else {
            None
        }
    }

    pub fn get_hypervisor_info(&self) -> Option<HypervisorInfo> {
        let res = cpuid!(EAX_HYPERVISOR_INFO);
        if res.eax > 0 {
            Some(HypervisorInfo { res: res })
        } else {
            None
        }
    }

    /// Extended functionality of CPU described here (including more supported features).
    /// This also contains a more detailed CPU model identifier.
    pub fn get_extended_function_info(&self) -> Option<ExtendedFunctionInfo> {
        let res = cpuid!(EAX_EXTENDED_FUNCTION_INFO);

        if res.eax == 0 {
            return None;
        }

        let mut ef = ExtendedFunctionInfo {
            max_eax_value: res.eax - EAX_EXTENDED_FUNCTION_INFO,
            data: [
                CpuIdResult {
                    eax: res.eax,
                    ebx: res.ebx,
                    ecx: res.ecx,
                    edx: res.edx,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
                CpuIdResult {
                    eax: 0,
                    ebx: 0,
                    ecx: 0,
                    edx: 0,
                },
            ],
        };

        let max_eax_value = min(ef.max_eax_value + 1, ef.data.len() as u32);
        for i in 1..max_eax_value {
            ef.data[i as usize] = cpuid!(EAX_EXTENDED_FUNCTION_INFO + i);
        }

        Some(ef)
    }

    pub fn get_memory_encryption_info(&self) -> Option<MemoryEncryptionInfo> {
        let res = cpuid!(EAX_EXTENDED_FUNCTION_INFO);
        if res.eax < EAX_MEMORY_ENCRYPTION_INFO {
            return None;
        }

        let res = cpuid!(EAX_MEMORY_ENCRYPTION_INFO);
        Some(MemoryEncryptionInfo {
            eax: MemoryEncryptionInfoEax { bits: res.eax },
            ebx: res.ebx,
            ecx: res.ecx,
            edx: res.edx,
        })
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct VendorInfo {
    ebx: u32,
    edx: u32,
    ecx: u32,
}

impl VendorInfo {
    /// Return vendor identification as human readable string.
    pub fn as_string<'a>(&'a self) -> &'a str {
        unsafe {
            let brand_string_start = self as *const VendorInfo as *const u8;
            let slice = slice::from_raw_parts(brand_string_start, 3 * 4);
            let byte_array: &'a [u8] = transmute(slice);
            str::from_utf8_unchecked(byte_array)
        }
    }
}

/// Used to iterate over cache information contained in cpuid instruction.
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct CacheInfoIter {
    current: u32,
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl Iterator for CacheInfoIter {
    type Item = CacheInfo;

    /// Iterate over all cache information.
    fn next(&mut self) -> Option<CacheInfo> {
        // Every byte of the 4 register values returned by cpuid
        // can contain information about a cache (except the
        // very first one).
        if self.current >= 4 * 4 {
            return None;
        }
        let reg_index = self.current % 4;
        let byte_index = self.current / 4;

        let reg = match reg_index {
            0 => self.eax,
            1 => self.ebx,
            2 => self.ecx,
            3 => self.edx,
            _ => unreachable!(),
        };

        let byte = as_bytes(&reg)[byte_index as usize];
        if byte == 0 {
            self.current += 1;
            return self.next();
        }

        for cache_info in CACHE_INFO_TABLE.into_iter() {
            if cache_info.num == byte {
                self.current += 1;
                return Some(*cache_info);
            }
        }

        None
    }
}

/// What type of cache are we dealing with?
#[derive(Copy, Clone, Debug)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub enum CacheInfoType {
    General,
    Cache,
    TLB,
    STLB,
    DTLB,
    Prefetch,
}

impl Default for CacheInfoType {
    fn default() -> CacheInfoType {
        CacheInfoType::General
    }
}

/// Describes any kind of cache (TLB, Data and Instruction caches plus prefetchers).
#[derive(Copy, Clone, Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct CacheInfo {
    /// Number as retrieved from cpuid
    pub num: u8,
    /// Cache type
    pub typ: CacheInfoType,
}

impl CacheInfo {
    /// Description of the cache (from Intel Manual)
    pub fn desc(&self) -> &'static str {
        match self.num {
            0x00 => "Null descriptor, this byte contains no information",
            0x01 => "Instruction TLB: 4 KByte pages, 4-way set associative, 32 entries",
            0x02 => "Instruction TLB: 4 MByte pages, fully associative, 2 entries",
            0x03 => "Data TLB: 4 KByte pages, 4-way set associative, 64 entries",
            0x04 => "Data TLB: 4 MByte pages, 4-way set associative, 8 entries",
            0x05 => "Data TLB1: 4 MByte pages, 4-way set associative, 32 entries",
            0x06 => "1st-level instruction cache: 8 KBytes, 4-way set associative, 32 byte line size",
            0x08 => "1st-level instruction cache: 16 KBytes, 4-way set associative, 32 byte line size",
            0x09 => "1st-level instruction cache: 32KBytes, 4-way set associative, 64 byte line size",
            0x0A => "1st-level data cache: 8 KBytes, 2-way set associative, 32 byte line size",
            0x0B => "Instruction TLB: 4 MByte pages, 4-way set associative, 4 entries",
            0x0C => "1st-level data cache: 16 KBytes, 4-way set associative, 32 byte line size",
            0x0D => "1st-level data cache: 16 KBytes, 4-way set associative, 64 byte line size",
            0x0E => "1st-level data cache: 24 KBytes, 6-way set associative, 64 byte line size",
            0x1D => "2nd-level cache: 128 KBytes, 2-way set associative, 64 byte line size",
            0x21 => "2nd-level cache: 256 KBytes, 8-way set associative, 64 byte line size",
            0x22 => "3rd-level cache: 512 KBytes, 4-way set associative, 64 byte line size, 2 lines per sector",
            0x23 => "3rd-level cache: 1 MBytes, 8-way set associative, 64 byte line size, 2 lines per sector",
            0x24 => "2nd-level cache: 1 MBytes, 16-way set associative, 64 byte line size",
            0x25 => "3rd-level cache: 2 MBytes, 8-way set associative, 64 byte line size, 2 lines per sector",
            0x29 => "3rd-level cache: 4 MBytes, 8-way set associative, 64 byte line size, 2 lines per sector",
            0x2C => "1st-level data cache: 32 KBytes, 8-way set associative, 64 byte line size",
            0x30 => "1st-level instruction cache: 32 KBytes, 8-way set associative, 64 byte line size",
            0x40 => "No 2nd-level cache or, if processor contains a valid 2nd-level cache, no 3rd-level cache",
            0x41 => "2nd-level cache: 128 KBytes, 4-way set associative, 32 byte line size",
            0x42 => "2nd-level cache: 256 KBytes, 4-way set associative, 32 byte line size",
            0x43 => "2nd-level cache: 512 KBytes, 4-way set associative, 32 byte line size",
            0x44 => "2nd-level cache: 1 MByte, 4-way set associative, 32 byte line size",
            0x45 => "2nd-level cache: 2 MByte, 4-way set associative, 32 byte line size",
            0x46 => "3rd-level cache: 4 MByte, 4-way set associative, 64 byte line size",
            0x47 => "3rd-level cache: 8 MByte, 8-way set associative, 64 byte line size",
            0x48 => "2nd-level cache: 3MByte, 12-way set associative, 64 byte line size",
            0x49 => "3rd-level cache: 4MB, 16-way set associative, 64-byte line size (Intel Xeon processor MP, Family 0FH, Model 06H); 2nd-level cache: 4 MByte, 16-way set ssociative, 64 byte line size",
            0x4A => "3rd-level cache: 6MByte, 12-way set associative, 64 byte line size",
            0x4B => "3rd-level cache: 8MByte, 16-way set associative, 64 byte line size",
            0x4C => "3rd-level cache: 12MByte, 12-way set associative, 64 byte line size",
            0x4D => "3rd-level cache: 16MByte, 16-way set associative, 64 byte line size",
            0x4E => "2nd-level cache: 6MByte, 24-way set associative, 64 byte line size",
            0x4F => "Instruction TLB: 4 KByte pages, 32 entries",
            0x50 => "Instruction TLB: 4 KByte and 2-MByte or 4-MByte pages, 64 entries",
            0x51 => "Instruction TLB: 4 KByte and 2-MByte or 4-MByte pages, 128 entries",
            0x52 => "Instruction TLB: 4 KByte and 2-MByte or 4-MByte pages, 256 entries",
            0x55 => "Instruction TLB: 2-MByte or 4-MByte pages, fully associative, 7 entries",
            0x56 => "Data TLB0: 4 MByte pages, 4-way set associative, 16 entries",
            0x57 => "Data TLB0: 4 KByte pages, 4-way associative, 16 entries",
            0x59 => "Data TLB0: 4 KByte pages, fully associative, 16 entries",
            0x5A => "Data TLB0: 2-MByte or 4 MByte pages, 4-way set associative, 32 entries",
            0x5B => "Data TLB: 4 KByte and 4 MByte pages, 64 entries",
            0x5C => "Data TLB: 4 KByte and 4 MByte pages,128 entries",
            0x5D => "Data TLB: 4 KByte and 4 MByte pages,256 entries",
            0x60 => "1st-level data cache: 16 KByte, 8-way set associative, 64 byte line size",
            0x61 => "Instruction TLB: 4 KByte pages, fully associative, 48 entries",
            0x63 => "Data TLB: 2 MByte or 4 MByte pages, 4-way set associative, 32 entries and a separate array with 1 GByte pages, 4-way set associative, 4 entries",
            0x64 => "Data TLB: 4 KByte pages, 4-way set associative, 512 entries",
            0x66 => "1st-level data cache: 8 KByte, 4-way set associative, 64 byte line size",
            0x67 => "1st-level data cache: 16 KByte, 4-way set associative, 64 byte line size",
            0x68 => "1st-level data cache: 32 KByte, 4-way set associative, 64 byte line size",
            0x6A => "uTLB: 4 KByte pages, 8-way set associative, 64 entries",
            0x6B => "DTLB: 4 KByte pages, 8-way set associative, 256 entries",
            0x6C => "DTLB: 2M/4M pages, 8-way set associative, 128 entries",
            0x6D => "DTLB: 1 GByte pages, fully associative, 16 entries",
            0x70 => "Trace cache: 12 K-μop, 8-way set associative",
            0x71 => "Trace cache: 16 K-μop, 8-way set associative",
            0x72 => "Trace cache: 32 K-μop, 8-way set associative",
            0x76 => "Instruction TLB: 2M/4M pages, fully associative, 8 entries",
            0x78 => "2nd-level cache: 1 MByte, 4-way set associative, 64byte line size",
            0x79 => "2nd-level cache: 128 KByte, 8-way set associative, 64 byte line size, 2 lines per sector",
            0x7A => "2nd-level cache: 256 KByte, 8-way set associative, 64 byte line size, 2 lines per sector",
            0x7B => "2nd-level cache: 512 KByte, 8-way set associative, 64 byte line size, 2 lines per sector",
            0x7C => "2nd-level cache: 1 MByte, 8-way set associative, 64 byte line size, 2 lines per sector",
            0x7D => "2nd-level cache: 2 MByte, 8-way set associative, 64byte line size",
            0x7F => "2nd-level cache: 512 KByte, 2-way set associative, 64-byte line size",
            0x80 => "2nd-level cache: 512 KByte, 8-way set associative, 64-byte line size",
            0x82 => "2nd-level cache: 256 KByte, 8-way set associative, 32 byte line size",
            0x83 => "2nd-level cache: 512 KByte, 8-way set associative, 32 byte line size",
            0x84 => "2nd-level cache: 1 MByte, 8-way set associative, 32 byte line size",
            0x85 => "2nd-level cache: 2 MByte, 8-way set associative, 32 byte line size",
            0x86 => "2nd-level cache: 512 KByte, 4-way set associative, 64 byte line size",
            0x87 => "2nd-level cache: 1 MByte, 8-way set associative, 64 byte line size",
            0xA0 => "DTLB: 4k pages, fully associative, 32 entries",
            0xB0 => "Instruction TLB: 4 KByte pages, 4-way set associative, 128 entries",
            0xB1 => "Instruction TLB: 2M pages, 4-way, 8 entries or 4M pages, 4-way, 4 entries",
            0xB2 => "Instruction TLB: 4KByte pages, 4-way set associative, 64 entries",
            0xB3 => "Data TLB: 4 KByte pages, 4-way set associative, 128 entries",
            0xB4 => "Data TLB1: 4 KByte pages, 4-way associative, 256 entries",
            0xB5 => "Instruction TLB: 4KByte pages, 8-way set associative, 64 entries",
            0xB6 => "Instruction TLB: 4KByte pages, 8-way set associative, 128 entries",
            0xBA => "Data TLB1: 4 KByte pages, 4-way associative, 64 entries",
            0xC0 => "Data TLB: 4 KByte and 4 MByte pages, 4-way associative, 8 entries",
            0xC1 => "Shared 2nd-Level TLB: 4 KByte/2MByte pages, 8-way associative, 1024 entries",
            0xC2 => "DTLB: 2 MByte/$MByte pages, 4-way associative, 16 entries",
            0xC3 => "Shared 2nd-Level TLB: 4 KByte /2 MByte pages, 6-way associative, 1536 entries. Also 1GBbyte pages, 4-way, 16 entries.",
            0xC4 => "DTLB: 2M/4M Byte pages, 4-way associative, 32 entries",
            0xCA => "Shared 2nd-Level TLB: 4 KByte pages, 4-way associative, 512 entries",
            0xD0 => "3rd-level cache: 512 KByte, 4-way set associative, 64 byte line size",
            0xD1 => "3rd-level cache: 1 MByte, 4-way set associative, 64 byte line size",
            0xD2 => "3rd-level cache: 2 MByte, 4-way set associative, 64 byte line size",
            0xD6 => "3rd-level cache: 1 MByte, 8-way set associative, 64 byte line size",
            0xD7 => "3rd-level cache: 2 MByte, 8-way set associative, 64 byte line size",
            0xD8 => "3rd-level cache: 4 MByte, 8-way set associative, 64 byte line size",
            0xDC => "3rd-level cache: 1.5 MByte, 12-way set associative, 64 byte line size",
            0xDD => "3rd-level cache: 3 MByte, 12-way set associative, 64 byte line size",
            0xDE => "3rd-level cache: 6 MByte, 12-way set associative, 64 byte line size",
            0xE2 => "3rd-level cache: 2 MByte, 16-way set associative, 64 byte line size",
            0xE3 => "3rd-level cache: 4 MByte, 16-way set associative, 64 byte line size",
            0xE4 => "3rd-level cache: 8 MByte, 16-way set associative, 64 byte line size",
            0xEA => "3rd-level cache: 12MByte, 24-way set associative, 64 byte line size",
            0xEB => "3rd-level cache: 18MByte, 24-way set associative, 64 byte line size",
            0xEC => "3rd-level cache: 24MByte, 24-way set associative, 64 byte line size",
            0xF0 => "64-Byte prefetching",
            0xF1 => "128-Byte prefetching",
            0xFE => "CPUID leaf 2 does not report TLB descriptor information; use CPUID leaf 18H to query TLB and other address translation parameters.",
            0xFF => "CPUID leaf 2 does not report cache descriptor information, use CPUID leaf 4 to query cache parameters",
            _ => "Unknown cache type!"
        }
    }
}

impl fmt::Display for CacheInfo {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let typ = match self.typ {
            CacheInfoType::General => "N/A",
            CacheInfoType::Cache => "Cache",
            CacheInfoType::TLB => "TLB",
            CacheInfoType::STLB => "STLB",
            CacheInfoType::DTLB => "DTLB",
            CacheInfoType::Prefetch => "Prefetcher",
        };

        write!(f, "{:x}:\t {}: {}", self.num, typ, self.desc())
    }
}

/// This table is taken from Intel manual (Section CPUID instruction).
pub const CACHE_INFO_TABLE: [CacheInfo; 108] = [
    CacheInfo {
        num: 0x00,
        typ: CacheInfoType::General,
    },
    CacheInfo {
        num: 0x01,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x02,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x03,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x04,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x05,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x06,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x08,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x09,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x0A,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x0B,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x0C,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x0D,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x0E,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x21,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x22,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x23,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x24,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x25,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x29,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x2C,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x30,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x40,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x41,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x42,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x43,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x44,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x45,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x46,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x47,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x48,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x49,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x4A,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x4B,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x4C,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x4D,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x4E,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x4F,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x50,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x51,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x52,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x55,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x56,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x57,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x59,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x5A,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x5B,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x5C,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x5D,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x60,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x61,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x63,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x66,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x67,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x68,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x6A,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x6B,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x6C,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x6D,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x70,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x71,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x72,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x76,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0x78,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x79,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x7A,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x7B,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x7C,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x7D,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x7F,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x80,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x82,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x83,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x84,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x85,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x86,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0x87,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xB0,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xB1,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xB2,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xB3,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xB4,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xB5,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xB6,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xBA,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xC0,
        typ: CacheInfoType::TLB,
    },
    CacheInfo {
        num: 0xC1,
        typ: CacheInfoType::STLB,
    },
    CacheInfo {
        num: 0xC2,
        typ: CacheInfoType::DTLB,
    },
    CacheInfo {
        num: 0xCA,
        typ: CacheInfoType::STLB,
    },
    CacheInfo {
        num: 0xD0,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xD1,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xD2,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xD6,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xD7,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xD8,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xDC,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xDD,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xDE,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xE2,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xE3,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xE4,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xEA,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xEB,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xEC,
        typ: CacheInfoType::Cache,
    },
    CacheInfo {
        num: 0xF0,
        typ: CacheInfoType::Prefetch,
    },
    CacheInfo {
        num: 0xF1,
        typ: CacheInfoType::Prefetch,
    },
    CacheInfo {
        num: 0xFE,
        typ: CacheInfoType::General,
    },
    CacheInfo {
        num: 0xFF,
        typ: CacheInfoType::General,
    },
];

impl fmt::Display for VendorInfo {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.as_string())
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ProcessorSerial {
    ecx: u32,
    edx: u32,
}

impl ProcessorSerial {
    /// Bits 00-31 of 96 bit processor serial number.
    /// (Available in Pentium III processor only; otherwise, the value in this register is reserved.)
    pub fn serial_lower(&self) -> u32 {
        self.ecx
    }

    /// Bits 32-63 of 96 bit processor serial number.
    /// (Available in Pentium III processor only; otherwise, the value in this register is reserved.)
    pub fn serial_middle(&self) -> u32 {
        self.edx
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct FeatureInfo {
    eax: u32,
    ebx: u32,
    edx_ecx: FeatureInfoFlags,
}

impl FeatureInfo {
    /// Version Information: Extended Family
    pub fn extended_family_id(&self) -> u8 {
        get_bits(self.eax, 20, 27) as u8
    }

    /// Version Information: Extended Model
    pub fn extended_model_id(&self) -> u8 {
        get_bits(self.eax, 16, 19) as u8
    }

    /// Version Information: Family
    pub fn family_id(&self) -> u8 {
        get_bits(self.eax, 8, 11) as u8
    }

    /// Version Information: Model
    pub fn model_id(&self) -> u8 {
        get_bits(self.eax, 4, 7) as u8
    }

    /// Version Information: Stepping ID
    pub fn stepping_id(&self) -> u8 {
        get_bits(self.eax, 0, 3) as u8
    }

    /// Brand Index
    pub fn brand_index(&self) -> u8 {
        get_bits(self.ebx, 0, 7) as u8
    }

    /// CLFLUSH line size (Value ∗ 8 = cache line size in bytes)
    pub fn cflush_cache_line_size(&self) -> u8 {
        get_bits(self.ebx, 8, 15) as u8
    }

    /// Initial APIC ID
    pub fn initial_local_apic_id(&self) -> u8 {
        get_bits(self.ebx, 24, 31) as u8
    }

    /// Maximum number of addressable IDs for logical processors in this physical package.
    pub fn max_logical_processor_ids(&self) -> u8 {
        get_bits(self.ebx, 16, 23) as u8
    }

    check_flag!(
        doc = "Streaming SIMD Extensions 3 (SSE3). A value of 1 indicates the processor \
               supports this technology.",
        has_sse3,
        edx_ecx,
        FeatureInfoFlags::SSE3
    );

    check_flag!(
        doc = "PCLMULQDQ. A value of 1 indicates the processor supports the PCLMULQDQ \
               instruction",
        has_pclmulqdq,
        edx_ecx,
        FeatureInfoFlags::PCLMULQDQ
    );

    check_flag!(
        doc = "64-bit DS Area. A value of 1 indicates the processor supports DS area \
               using 64-bit layout",
        has_ds_area,
        edx_ecx,
        FeatureInfoFlags::DTES64
    );

    check_flag!(
        doc = "MONITOR/MWAIT. A value of 1 indicates the processor supports this feature.",
        has_monitor_mwait,
        edx_ecx,
        FeatureInfoFlags::MONITOR
    );

    check_flag!(
        doc = "CPL Qualified Debug Store. A value of 1 indicates the processor supports \
               the extensions to the  Debug Store feature to allow for branch message \
               storage qualified by CPL.",
        has_cpl,
        edx_ecx,
        FeatureInfoFlags::DSCPL
    );

    check_flag!(
        doc = "Virtual Machine Extensions. A value of 1 indicates that the processor \
               supports this technology.",
        has_vmx,
        edx_ecx,
        FeatureInfoFlags::VMX
    );

    check_flag!(
        doc = "Safer Mode Extensions. A value of 1 indicates that the processor supports \
               this technology. See Chapter 5, Safer Mode Extensions Reference.",
        has_smx,
        edx_ecx,
        FeatureInfoFlags::SMX
    );

    check_flag!(
        doc = "Enhanced Intel SpeedStep® technology. A value of 1 indicates that the \
               processor supports this technology.",
        has_eist,
        edx_ecx,
        FeatureInfoFlags::EIST
    );

    check_flag!(
        doc = "Thermal Monitor 2. A value of 1 indicates whether the processor supports \
               this technology.",
        has_tm2,
        edx_ecx,
        FeatureInfoFlags::TM2
    );

    check_flag!(
        doc = "A value of 1 indicates the presence of the Supplemental Streaming SIMD \
               Extensions 3 (SSSE3). A value of 0 indicates the instruction extensions \
               are not present in the processor",
        has_ssse3,
        edx_ecx,
        FeatureInfoFlags::SSSE3
    );

    check_flag!(
        doc = "L1 Context ID. A value of 1 indicates the L1 data cache mode can be set \
               to either adaptive mode or shared mode. A value of 0 indicates this \
               feature is not supported. See definition of the IA32_MISC_ENABLE MSR Bit \
               24 (L1 Data Cache Context Mode) for details.",
        has_cnxtid,
        edx_ecx,
        FeatureInfoFlags::CNXTID
    );

    check_flag!(
        doc = "A value of 1 indicates the processor supports FMA extensions using YMM \
               state.",
        has_fma,
        edx_ecx,
        FeatureInfoFlags::FMA
    );

    check_flag!(
        doc = "CMPXCHG16B Available. A value of 1 indicates that the feature is \
               available. See the CMPXCHG8B/CMPXCHG16B Compare and Exchange Bytes \
               section. 14",
        has_cmpxchg16b,
        edx_ecx,
        FeatureInfoFlags::CMPXCHG16B
    );

    check_flag!(
        doc = "Perfmon and Debug Capability: A value of 1 indicates the processor \
               supports the performance   and debug feature indication MSR \
               IA32_PERF_CAPABILITIES.",
        has_pdcm,
        edx_ecx,
        FeatureInfoFlags::PDCM
    );

    check_flag!(
        doc = "Process-context identifiers. A value of 1 indicates that the processor \
               supports PCIDs and the software may set CR4.PCIDE to 1.",
        has_pcid,
        edx_ecx,
        FeatureInfoFlags::PCID
    );

    check_flag!(
        doc = "A value of 1 indicates the processor supports the ability to prefetch \
               data from a memory mapped device.",
        has_dca,
        edx_ecx,
        FeatureInfoFlags::DCA
    );

    check_flag!(
        doc = "A value of 1 indicates that the processor supports SSE4.1.",
        has_sse41,
        edx_ecx,
        FeatureInfoFlags::SSE41
    );

    check_flag!(
        doc = "A value of 1 indicates that the processor supports SSE4.2.",
        has_sse42,
        edx_ecx,
        FeatureInfoFlags::SSE42
    );

    check_flag!(
        doc = "A value of 1 indicates that the processor supports x2APIC feature.",
        has_x2apic,
        edx_ecx,
        FeatureInfoFlags::X2APIC
    );

    check_flag!(
        doc = "A value of 1 indicates that the processor supports MOVBE instruction.",
        has_movbe,
        edx_ecx,
        FeatureInfoFlags::MOVBE
    );

    check_flag!(
        doc = "A value of 1 indicates that the processor supports the POPCNT instruction.",
        has_popcnt,
        edx_ecx,
        FeatureInfoFlags::POPCNT
    );

    check_flag!(
        doc = "A value of 1 indicates that the processors local APIC timer supports \
               one-shot operation using a TSC deadline value.",
        has_tsc_deadline,
        edx_ecx,
        FeatureInfoFlags::TSC_DEADLINE
    );

    check_flag!(
        doc = "A value of 1 indicates that the processor supports the AESNI instruction \
               extensions.",
        has_aesni,
        edx_ecx,
        FeatureInfoFlags::AESNI
    );

    check_flag!(
        doc = "A value of 1 indicates that the processor supports the XSAVE/XRSTOR \
               processor extended states feature, the XSETBV/XGETBV instructions, and \
               XCR0.",
        has_xsave,
        edx_ecx,
        FeatureInfoFlags::XSAVE
    );

    check_flag!(
        doc = "A value of 1 indicates that the OS has enabled XSETBV/XGETBV instructions \
               to access XCR0, and support for processor extended state management using \
               XSAVE/XRSTOR.",
        has_oxsave,
        edx_ecx,
        FeatureInfoFlags::OSXSAVE
    );

    check_flag!(
        doc = "A value of 1 indicates the processor supports the AVX instruction \
               extensions.",
        has_avx,
        edx_ecx,
        FeatureInfoFlags::AVX
    );

    check_flag!(
        doc = "A value of 1 indicates that processor supports 16-bit floating-point \
               conversion instructions.",
        has_f16c,
        edx_ecx,
        FeatureInfoFlags::F16C
    );

    check_flag!(
        doc = "A value of 1 indicates that processor supports RDRAND instruction.",
        has_rdrand,
        edx_ecx,
        FeatureInfoFlags::RDRAND
    );

    check_flag!(
        doc = "Floating Point Unit On-Chip. The processor contains an x87 FPU.",
        has_fpu,
        edx_ecx,
        FeatureInfoFlags::FPU
    );

    check_flag!(
        doc = "Virtual 8086 Mode Enhancements. Virtual 8086 mode enhancements, including \
               CR4.VME for controlling the feature, CR4.PVI for protected mode virtual \
               interrupts, software interrupt indirection, expansion of the TSS with the \
               software indirection bitmap, and EFLAGS.VIF and EFLAGS.VIP flags.",
        has_vme,
        edx_ecx,
        FeatureInfoFlags::VME
    );

    check_flag!(
        doc = "Debugging Extensions. Support for I/O breakpoints, including CR4.DE for \
               controlling the feature, and optional trapping of accesses to DR4 and DR5.",
        has_de,
        edx_ecx,
        FeatureInfoFlags::DE
    );

    check_flag!(
        doc = "Page Size Extension. Large pages of size 4 MByte are supported, including \
               CR4.PSE for controlling the feature, the defined dirty bit in PDE (Page \
               Directory Entries), optional reserved bit trapping in CR3, PDEs, and PTEs.",
        has_pse,
        edx_ecx,
        FeatureInfoFlags::PSE
    );

    check_flag!(
        doc = "Time Stamp Counter. The RDTSC instruction is supported, including CR4.TSD \
               for controlling privilege.",
        has_tsc,
        edx_ecx,
        FeatureInfoFlags::TSC
    );

    check_flag!(
        doc = "Model Specific Registers RDMSR and WRMSR Instructions. The RDMSR and \
               WRMSR instructions are supported. Some of the MSRs are implementation \
               dependent.",
        has_msr,
        edx_ecx,
        FeatureInfoFlags::MSR
    );

    check_flag!(
        doc = "Physical Address Extension. Physical addresses greater than 32 bits are \
               supported: extended page table entry formats, an extra level in the page \
               translation tables is defined, 2-MByte pages are supported instead of 4 \
               Mbyte pages if PAE bit is 1.",
        has_pae,
        edx_ecx,
        FeatureInfoFlags::PAE
    );

    check_flag!(
        doc = "Machine Check Exception. Exception 18 is defined for Machine Checks, \
               including CR4.MCE for controlling the feature. This feature does not \
               define the model-specific implementations of machine-check error logging, \
               reporting, and processor shutdowns. Machine Check exception handlers may \
               have to depend on processor version to do model specific processing of \
               the exception, or test for the presence of the Machine Check feature.",
        has_mce,
        edx_ecx,
        FeatureInfoFlags::MCE
    );

    check_flag!(
        doc = "CMPXCHG8B Instruction. The compare-and-exchange 8 bytes (64 bits) \
               instruction is supported (implicitly locked and atomic).",
        has_cmpxchg8b,
        edx_ecx,
        FeatureInfoFlags::CX8
    );

    check_flag!(
        doc = "APIC On-Chip. The processor contains an Advanced Programmable Interrupt \
               Controller (APIC), responding to memory mapped commands in the physical \
               address range FFFE0000H to FFFE0FFFH (by default - some processors permit \
               the APIC to be relocated).",
        has_apic,
        edx_ecx,
        FeatureInfoFlags::APIC
    );

    check_flag!(
        doc = "SYSENTER and SYSEXIT Instructions. The SYSENTER and SYSEXIT and \
               associated MSRs are supported.",
        has_sysenter_sysexit,
        edx_ecx,
        FeatureInfoFlags::SEP
    );

    check_flag!(
        doc = "Memory Type Range Registers. MTRRs are supported. The MTRRcap MSR \
               contains feature bits that describe what memory types are supported, how \
               many variable MTRRs are supported, and whether fixed MTRRs are supported.",
        has_mtrr,
        edx_ecx,
        FeatureInfoFlags::MTRR
    );

    check_flag!(
        doc = "Page Global Bit. The global bit is supported in paging-structure entries \
               that map a page, indicating TLB entries that are common to different \
               processes and need not be flushed. The CR4.PGE bit controls this feature.",
        has_pge,
        edx_ecx,
        FeatureInfoFlags::PGE
    );

    check_flag!(
        doc = "Machine Check Architecture. A value of 1 indicates the Machine Check \
               Architecture of reporting machine errors is supported. The MCG_CAP MSR \
               contains feature bits describing how many banks of error reporting MSRs \
               are supported.",
        has_mca,
        edx_ecx,
        FeatureInfoFlags::MCA
    );

    check_flag!(
        doc = "Conditional Move Instructions. The conditional move instruction CMOV is \
               supported. In addition, if x87 FPU is present as indicated by the \
               CPUID.FPU feature bit, then the FCOMI and FCMOV instructions are supported",
        has_cmov,
        edx_ecx,
        FeatureInfoFlags::CMOV
    );

    check_flag!(
        doc = "Page Attribute Table. Page Attribute Table is supported. This feature \
               augments the Memory Type Range Registers (MTRRs), allowing an operating \
               system to specify attributes of memory accessed through a linear address \
               on a 4KB granularity.",
        has_pat,
        edx_ecx,
        FeatureInfoFlags::PAT
    );

    check_flag!(
        doc = "36-Bit Page Size Extension. 4-MByte pages addressing physical memory \
               beyond 4 GBytes are supported with 32-bit paging. This feature indicates \
               that upper bits of the physical address of a 4-MByte page are encoded in \
               bits 20:13 of the page-directory entry. Such physical addresses are \
               limited by MAXPHYADDR and may be up to 40 bits in size.",
        has_pse36,
        edx_ecx,
        FeatureInfoFlags::PSE36
    );

    check_flag!(
        doc = "Processor Serial Number. The processor supports the 96-bit processor \
               identification number feature and the feature is enabled.",
        has_psn,
        edx_ecx,
        FeatureInfoFlags::PSN
    );

    check_flag!(
        doc = "CLFLUSH Instruction. CLFLUSH Instruction is supported.",
        has_clflush,
        edx_ecx,
        FeatureInfoFlags::CLFSH
    );

    check_flag!(
        doc = "Debug Store. The processor supports the ability to write debug \
               information into a memory resident buffer. This feature is used by the \
               branch trace store (BTS) and processor event-based sampling (PEBS) \
               facilities (see Chapter 23, Introduction to Virtual-Machine Extensions, \
               in the Intel® 64 and IA-32 Architectures Software Developers Manual, \
               Volume 3C).",
        has_ds,
        edx_ecx,
        FeatureInfoFlags::DS
    );

    check_flag!(
        doc = "Thermal Monitor and Software Controlled Clock Facilities. The processor \
               implements internal MSRs that allow processor temperature to be monitored \
               and processor performance to be modulated in predefined duty cycles under \
               software control.",
        has_acpi,
        edx_ecx,
        FeatureInfoFlags::ACPI
    );

    check_flag!(
        doc = "Intel MMX Technology. The processor supports the Intel MMX technology.",
        has_mmx,
        edx_ecx,
        FeatureInfoFlags::MMX
    );

    check_flag!(
        doc = "FXSAVE and FXRSTOR Instructions. The FXSAVE and FXRSTOR instructions are \
               supported for fast save and restore of the floating point context. \
               Presence of this bit also indicates that CR4.OSFXSR is available for an \
               operating system to indicate that it supports the FXSAVE and FXRSTOR \
               instructions.",
        has_fxsave_fxstor,
        edx_ecx,
        FeatureInfoFlags::FXSR
    );

    check_flag!(
        doc = "SSE. The processor supports the SSE extensions.",
        has_sse,
        edx_ecx,
        FeatureInfoFlags::SSE
    );

    check_flag!(
        doc = "SSE2. The processor supports the SSE2 extensions.",
        has_sse2,
        edx_ecx,
        FeatureInfoFlags::SSE2
    );

    check_flag!(
        doc = "Self Snoop. The processor supports the management of conflicting memory \
               types by performing a snoop of its own cache structure for transactions \
               issued to the bus.",
        has_ss,
        edx_ecx,
        FeatureInfoFlags::SS
    );

    check_flag!(
        doc = "Max APIC IDs reserved field is Valid. A value of 0 for HTT indicates \
               there is only a single logical processor in the package and software \
               should assume only a single APIC ID is reserved.  A value of 1 for HTT \
               indicates the value in CPUID.1.EBX\\[23:16\\] (the Maximum number of \
               addressable IDs for logical processors in this package) is valid for the \
               package.",
        has_htt,
        edx_ecx,
        FeatureInfoFlags::HTT
    );

    check_flag!(
        doc = "Thermal Monitor. The processor implements the thermal monitor automatic \
               thermal control circuitry (TCC).",
        has_tm,
        edx_ecx,
        FeatureInfoFlags::TM
    );

    check_flag!(
        doc = "Pending Break Enable. The processor supports the use of the FERR#/PBE# \
               pin when the processor is in the stop-clock state (STPCLK# is asserted) \
               to signal the processor that an interrupt is pending and that the \
               processor should return to normal operation to handle the interrupt. Bit \
               10 (PBE enable) in the IA32_MISC_ENABLE MSR enables this capability.",
        has_pbe,
        edx_ecx,
        FeatureInfoFlags::PBE
    );
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct FeatureInfoFlags: u64 {

        // ECX flags

        /// Streaming SIMD Extensions 3 (SSE3). A value of 1 indicates the processor supports this technology.
        const SSE3 = 1 << 0;
        /// PCLMULQDQ. A value of 1 indicates the processor supports the PCLMULQDQ instruction
        const PCLMULQDQ = 1 << 1;
        /// 64-bit DS Area. A value of 1 indicates the processor supports DS area using 64-bit layout
        const DTES64 = 1 << 2;
        /// MONITOR/MWAIT. A value of 1 indicates the processor supports this feature.
        const MONITOR = 1 << 3;
        /// CPL Qualified Debug Store. A value of 1 indicates the processor supports the extensions to the  Debug Store feature to allow for branch message storage qualified by CPL.
        const DSCPL = 1 << 4;
        /// Virtual Machine Extensions. A value of 1 indicates that the processor supports this technology.
        const VMX = 1 << 5;
        /// Safer Mode Extensions. A value of 1 indicates that the processor supports this technology. See Chapter 5, Safer Mode Extensions Reference.
        const SMX = 1 << 6;
        /// Enhanced Intel SpeedStep® technology. A value of 1 indicates that the processor supports this technology.
        const EIST = 1 << 7;
        /// Thermal Monitor 2. A value of 1 indicates whether the processor supports this technology.
        const TM2 = 1 << 8;
        /// A value of 1 indicates the presence of the Supplemental Streaming SIMD Extensions 3 (SSSE3). A value of 0 indicates the instruction extensions are not present in the processor
        const SSSE3 = 1 << 9;
        /// L1 Context ID. A value of 1 indicates the L1 data cache mode can be set to either adaptive mode or shared mode. A value of 0 indicates this feature is not supported. See definition of the IA32_MISC_ENABLE MSR Bit 24 (L1 Data Cache Context Mode) for details.
        const CNXTID = 1 << 10;
        /// A value of 1 indicates the processor supports FMA extensions using YMM state.
        const FMA = 1 << 12;
        /// CMPXCHG16B Available. A value of 1 indicates that the feature is available. See the CMPXCHG8B/CMPXCHG16B Compare and Exchange Bytes section. 14
        const CMPXCHG16B = 1 << 13;
        /// Perfmon and Debug Capability: A value of 1 indicates the processor supports the performance   and debug feature indication MSR IA32_PERF_CAPABILITIES.
        const PDCM = 1 << 15;
        /// Process-context identifiers. A value of 1 indicates that the processor supports PCIDs and the software may set CR4.PCIDE to 1.
        const PCID = 1 << 17;
        /// A value of 1 indicates the processor supports the ability to prefetch data from a memory mapped device.
        const DCA = 1 << 18;
        /// A value of 1 indicates that the processor supports SSE4.1.
        const SSE41 = 1 << 19;
        /// A value of 1 indicates that the processor supports SSE4.2.
        const SSE42 = 1 << 20;
        /// A value of 1 indicates that the processor supports x2APIC feature.
        const X2APIC = 1 << 21;
        /// A value of 1 indicates that the processor supports MOVBE instruction.
        const MOVBE = 1 << 22;
        /// A value of 1 indicates that the processor supports the POPCNT instruction.
        const POPCNT = 1 << 23;
        /// A value of 1 indicates that the processors local APIC timer supports one-shot operation using a TSC deadline value.
        const TSC_DEADLINE = 1 << 24;
        /// A value of 1 indicates that the processor supports the AESNI instruction extensions.
        const AESNI = 1 << 25;
        /// A value of 1 indicates that the processor supports the XSAVE/XRSTOR processor extended states feature, the XSETBV/XGETBV instructions, and XCR0.
        const XSAVE = 1 << 26;
        /// A value of 1 indicates that the OS has enabled XSETBV/XGETBV instructions to access XCR0, and support for processor extended state management using XSAVE/XRSTOR.
        const OSXSAVE = 1 << 27;
        /// A value of 1 indicates the processor supports the AVX instruction extensions.
        const AVX = 1 << 28;
        /// A value of 1 indicates that processor supports 16-bit floating-point conversion instructions.
        const F16C = 1 << 29;
        /// A value of 1 indicates that processor supports RDRAND instruction.
        const RDRAND = 1 << 30;


        // EDX flags

        /// Floating Point Unit On-Chip. The processor contains an x87 FPU.
        const FPU = 1 << (32 + 0);
        /// Virtual 8086 Mode Enhancements. Virtual 8086 mode enhancements, including CR4.VME for controlling the feature, CR4.PVI for protected mode virtual interrupts, software interrupt indirection, expansion of the TSS with the software indirection bitmap, and EFLAGS.VIF and EFLAGS.VIP flags.
        const VME = 1 << (32 + 1);
        /// Debugging Extensions. Support for I/O breakpoints, including CR4.DE for controlling the feature, and optional trapping of accesses to DR4 and DR5.
        const DE = 1 << (32 + 2);
        /// Page Size Extension. Large pages of size 4 MByte are supported, including CR4.PSE for controlling the feature, the defined dirty bit in PDE (Page Directory Entries), optional reserved bit trapping in CR3, PDEs, and PTEs.
        const PSE = 1 << (32 + 3);
        /// Time Stamp Counter. The RDTSC instruction is supported, including CR4.TSD for controlling privilege.
        const TSC = 1 << (32 + 4);
        /// Model Specific Registers RDMSR and WRMSR Instructions. The RDMSR and WRMSR instructions are supported. Some of the MSRs are implementation dependent.
        const MSR = 1 << (32 + 5);
        /// Physical Address Extension. Physical addresses greater than 32 bits are supported: extended page table entry formats, an extra level in the page translation tables is defined, 2-MByte pages are supported instead of 4 Mbyte pages if PAE bit is 1.
        const PAE = 1 << (32 + 6);
        /// Machine Check Exception. Exception 18 is defined for Machine Checks, including CR4.MCE for controlling the feature. This feature does not define the model-specific implementations of machine-check error logging, reporting, and processor shutdowns. Machine Check exception handlers may have to depend on processor version to do model specific processing of the exception, or test for the presence of the Machine Check feature.
        const MCE = 1 << (32 + 7);
        /// CMPXCHG8B Instruction. The compare-and-exchange 8 bytes (64 bits) instruction is supported (implicitly locked and atomic).
        const CX8 = 1 << (32 + 8);
        /// APIC On-Chip. The processor contains an Advanced Programmable Interrupt Controller (APIC), responding to memory mapped commands in the physical address range FFFE0000H to FFFE0FFFH (by default - some processors permit the APIC to be relocated).
        const APIC = 1 << (32 + 9);
        /// SYSENTER and SYSEXIT Instructions. The SYSENTER and SYSEXIT and associated MSRs are supported.
        const SEP = 1 << (32 + 11);
        /// Memory Type Range Registers. MTRRs are supported. The MTRRcap MSR contains feature bits that describe what memory types are supported, how many variable MTRRs are supported, and whether fixed MTRRs are supported.
        const MTRR = 1 << (32 + 12);
        /// Page Global Bit. The global bit is supported in paging-structure entries that map a page, indicating TLB entries that are common to different processes and need not be flushed. The CR4.PGE bit controls this feature.
        const PGE = 1 << (32 + 13);
        /// Machine Check Architecture. The Machine Check exArchitecture, which provides a compatible mechanism for error reporting in P6 family, Pentium 4, Intel Xeon processors, and future processors, is supported. The MCG_CAP MSR contains feature bits describing how many banks of error reporting MSRs are supported.
        const MCA = 1 << (32 + 14);
        /// Conditional Move Instructions. The conditional move instruction CMOV is supported. In addition, if x87 FPU is present as indicated by the CPUID.FPU feature bit, then the FCOMI and FCMOV instructions are supported
        const CMOV = 1 << (32 + 15);
        /// Page Attribute Table. Page Attribute Table is supported. This feature augments the Memory Type Range Registers (MTRRs), allowing an operating system to specify attributes of memory accessed through a linear address on a 4KB granularity.
        const PAT = 1 << (32 + 16);
        /// 36-Bit Page Size Extension. 4-MByte pages addressing physical memory beyond 4 GBytes are supported with 32-bit paging. This feature indicates that upper bits of the physical address of a 4-MByte page are encoded in bits 20:13 of the page-directory entry. Such physical addresses are limited by MAXPHYADDR and may be up to 40 bits in size.
        const PSE36 = 1 << (32 + 17);
        /// Processor Serial Number. The processor supports the 96-bit processor identification number feature and the feature is enabled.
        const PSN = 1 << (32 + 18);
        /// CLFLUSH Instruction. CLFLUSH Instruction is supported.
        const CLFSH = 1 << (32 + 19);
        /// Debug Store. The processor supports the ability to write debug information into a memory resident buffer. This feature is used by the branch trace store (BTS) and precise event-based sampling (PEBS) facilities (see Chapter 23, Introduction to Virtual-Machine Extensions, in the Intel® 64 and IA-32 Architectures Software Developers Manual, Volume 3C).
        const DS = 1 << (32 + 21);
        /// Thermal Monitor and Software Controlled Clock Facilities. The processor implements internal MSRs that allow processor temperature to be monitored and processor performance to be modulated in predefined duty cycles under software control.
        const ACPI = 1 << (32 + 22);
        /// Intel MMX Technology. The processor supports the Intel MMX technology.
        const MMX = 1 << (32 + 23);
        /// FXSAVE and FXRSTOR Instructions. The FXSAVE and FXRSTOR instructions are supported for fast save and restore of the floating point context. Presence of this bit also indicates that CR4.OSFXSR is available for an operating system to indicate that it supports the FXSAVE and FXRSTOR instructions.
        const FXSR = 1 << (32 + 24);
        /// SSE. The processor supports the SSE extensions.
        const SSE = 1 << (32 + 25);
        /// SSE2. The processor supports the SSE2 extensions.
        const SSE2 = 1 << (32 + 26);
        /// Self Snoop. The processor supports the management of conflicting memory types by performing a snoop of its own cache structure for transactions issued to the bus.
        const SS = 1 << (32 + 27);
        /// Max APIC IDs reserved field is Valid. A value of 0 for HTT indicates there is only a single logical processor in the package and software should assume only a single APIC ID is reserved.  A value of 1 for HTT indicates the value in CPUID.1.EBX[23:16] (the Maximum number of addressable IDs for logical processors in this package) is valid for the package.
        const HTT = 1 << (32 + 28);
        /// Thermal Monitor. The processor implements the thermal monitor automatic thermal control circuitry (TCC).
        const TM = 1 << (32 + 29);
        /// Pending Break Enable. The processor supports the use of the FERR#/PBE# pin when the processor is in the stop-clock state (STPCLK# is asserted) to signal the processor that an interrupt is pending and that the processor should return to normal operation to handle the interrupt. Bit 10 (PBE enable) in the IA32_MISC_ENABLE MSR enables this capability.
        const PBE = 1 << (32 + 31);
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct CacheParametersIter {
    current: u32,
}

impl Iterator for CacheParametersIter {
    type Item = CacheParameter;

    /// Iterate over all caches for this CPU.
    /// Note: cpuid is called every-time we this function to get information
    /// about next cache.
    fn next(&mut self) -> Option<CacheParameter> {
        let res = cpuid!(EAX_CACHE_PARAMETERS, self.current);
        let cp = CacheParameter {
            eax: res.eax,
            ebx: res.ebx,
            ecx: res.ecx,
            edx: res.edx,
        };

        match cp.cache_type() {
            CacheType::Null => None,
            CacheType::Reserved => None,
            _ => {
                self.current += 1;
                Some(cp)
            }
        }
    }
}

#[derive(Copy, Clone, Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct CacheParameter {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

#[derive(PartialEq, Eq, Debug)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub enum CacheType {
    /// Null - No more caches
    Null = 0,
    /// Data cache
    Data,
    /// Instruction cache
    Instruction,
    /// Data and Instruction cache
    Unified,
    /// 4-31 = Reserved
    Reserved,
}

impl Default for CacheType {
    fn default() -> CacheType {
        CacheType::Null
    }
}

impl CacheParameter {
    /// Cache Type
    pub fn cache_type(&self) -> CacheType {
        let typ = get_bits(self.eax, 0, 4) as u8;
        match typ {
            0 => CacheType::Null,
            1 => CacheType::Data,
            2 => CacheType::Instruction,
            3 => CacheType::Unified,
            _ => CacheType::Reserved,
        }
    }

    /// Cache Level (starts at 1)
    pub fn level(&self) -> u8 {
        get_bits(self.eax, 5, 7) as u8
    }

    /// Self Initializing cache level (does not need SW initialization).
    pub fn is_self_initializing(&self) -> bool {
        get_bits(self.eax, 8, 8) == 1
    }

    /// Fully Associative cache
    pub fn is_fully_associative(&self) -> bool {
        get_bits(self.eax, 9, 9) == 1
    }

    /// Maximum number of addressable IDs for logical processors sharing this cache
    pub fn max_cores_for_cache(&self) -> usize {
        (get_bits(self.eax, 14, 25) + 1) as usize
    }

    /// Maximum number of addressable IDs for processor cores in the physical package
    pub fn max_cores_for_package(&self) -> usize {
        (get_bits(self.eax, 26, 31) + 1) as usize
    }

    /// System Coherency Line Size (Bits 11-00)
    pub fn coherency_line_size(&self) -> usize {
        (get_bits(self.ebx, 0, 11) + 1) as usize
    }

    /// Physical Line partitions (Bits 21-12)
    pub fn physical_line_partitions(&self) -> usize {
        (get_bits(self.ebx, 12, 21) + 1) as usize
    }

    /// Ways of associativity (Bits 31-22)
    pub fn associativity(&self) -> usize {
        (get_bits(self.ebx, 22, 31) + 1) as usize
    }

    /// Number of Sets (Bits 31-00)
    pub fn sets(&self) -> usize {
        (self.ecx + 1) as usize
    }

    /// Write-Back Invalidate/Invalidate (Bit 0)
    /// False: WBINVD/INVD from threads sharing this cache acts upon lower level caches for threads sharing this cache.
    /// True: WBINVD/INVD is not guaranteed to act upon lower level caches of non-originating threads sharing this cache.
    pub fn is_write_back_invalidate(&self) -> bool {
        get_bits(self.edx, 0, 0) == 1
    }

    /// Cache Inclusiveness (Bit 1)
    /// False: Cache is not inclusive of lower cache levels.
    /// True: Cache is inclusive of lower cache levels.
    pub fn is_inclusive(&self) -> bool {
        get_bits(self.edx, 1, 1) == 1
    }

    /// Complex Cache Indexing (Bit 2)
    /// False: Direct mapped cache.
    /// True: A complex function is used to index the cache, potentially using all address bits.
    pub fn has_complex_indexing(&self) -> bool {
        get_bits(self.edx, 2, 2) == 1
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct MonitorMwaitInfo {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl MonitorMwaitInfo {
    /// Smallest monitor-line size in bytes (default is processor's monitor granularity)
    pub fn smallest_monitor_line(&self) -> u16 {
        get_bits(self.eax, 0, 15) as u16
    }

    /// Largest monitor-line size in bytes (default is processor's monitor granularity
    pub fn largest_monitor_line(&self) -> u16 {
        get_bits(self.ebx, 0, 15) as u16
    }

    ///  Enumeration of Monitor-Mwait extensions (beyond EAX and EBX registers) supported
    pub fn extensions_supported(&self) -> bool {
        get_bits(self.ecx, 0, 0) == 1
    }

    ///  Supports treating interrupts as break-event for MWAIT, even when interrupts disabled
    pub fn interrupts_as_break_event(&self) -> bool {
        get_bits(self.ecx, 1, 1) == 1
    }

    /// Number of C0 sub C-states supported using MWAIT (Bits 03 - 00)
    pub fn supported_c0_states(&self) -> u16 {
        get_bits(self.edx, 0, 3) as u16
    }

    /// Number of C1 sub C-states supported using MWAIT (Bits 07 - 04)
    pub fn supported_c1_states(&self) -> u16 {
        get_bits(self.edx, 4, 7) as u16
    }

    /// Number of C2 sub C-states supported using MWAIT (Bits 11 - 08)
    pub fn supported_c2_states(&self) -> u16 {
        get_bits(self.edx, 8, 11) as u16
    }

    /// Number of C3 sub C-states supported using MWAIT (Bits 15 - 12)
    pub fn supported_c3_states(&self) -> u16 {
        get_bits(self.edx, 12, 15) as u16
    }

    /// Number of C4 sub C-states supported using MWAIT (Bits 19 - 16)
    pub fn supported_c4_states(&self) -> u16 {
        get_bits(self.edx, 16, 19) as u16
    }

    /// Number of C5 sub C-states supported using MWAIT (Bits 23 - 20)
    pub fn supported_c5_states(&self) -> u16 {
        get_bits(self.edx, 20, 23) as u16
    }

    /// Number of C6 sub C-states supported using MWAIT (Bits 27 - 24)
    pub fn supported_c6_states(&self) -> u16 {
        get_bits(self.edx, 24, 27) as u16
    }

    /// Number of C7 sub C-states supported using MWAIT (Bits 31 - 28)
    pub fn supported_c7_states(&self) -> u16 {
        get_bits(self.edx, 28, 31) as u16
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ThermalPowerInfo {
    eax: ThermalPowerFeaturesEax,
    ebx: u32,
    ecx: ThermalPowerFeaturesEcx,
    edx: u32,
}

impl ThermalPowerInfo {
    /// Number of Interrupt Thresholds in Digital Thermal Sensor
    pub fn dts_irq_threshold(&self) -> u8 {
        get_bits(self.ebx, 0, 3) as u8
    }

    check_flag!(
        doc = "Digital temperature sensor is supported if set.",
        has_dts,
        eax,
        ThermalPowerFeaturesEax::DTS
    );

    check_flag!(
        doc = "Intel Turbo Boost Technology Available (see description of \
               IA32_MISC_ENABLE\\[38\\]).",
        has_turbo_boost,
        eax,
        ThermalPowerFeaturesEax::TURBO_BOOST
    );

    check_flag!(
        doc = "ARAT. APIC-Timer-always-running feature is supported if set.",
        has_arat,
        eax,
        ThermalPowerFeaturesEax::ARAT
    );

    check_flag!(
        doc = "PLN. Power limit notification controls are supported if set.",
        has_pln,
        eax,
        ThermalPowerFeaturesEax::PLN
    );

    check_flag!(
        doc = "ECMD. Clock modulation duty cycle extension is supported if set.",
        has_ecmd,
        eax,
        ThermalPowerFeaturesEax::ECMD
    );

    check_flag!(
        doc = "PTM. Package thermal management is supported if set.",
        has_ptm,
        eax,
        ThermalPowerFeaturesEax::PTM
    );

    check_flag!(
        doc = "HWP. HWP base registers (IA32_PM_ENABLE[bit 0], IA32_HWP_CAPABILITIES, \
               IA32_HWP_REQUEST, IA32_HWP_STATUS) are supported if set.",
        has_hwp,
        eax,
        ThermalPowerFeaturesEax::HWP
    );

    check_flag!(
        doc = "HWP Notification. IA32_HWP_INTERRUPT MSR is supported if set.",
        has_hwp_notification,
        eax,
        ThermalPowerFeaturesEax::HWP_NOTIFICATION
    );

    check_flag!(
        doc = "HWP Activity Window. IA32_HWP_REQUEST[bits 41:32] is supported if set.",
        has_hwp_activity_window,
        eax,
        ThermalPowerFeaturesEax::HWP_ACTIVITY_WINDOW
    );

    check_flag!(
        doc =
            "HWP Energy Performance Preference. IA32_HWP_REQUEST[bits 31:24] is supported if set.",
        has_hwp_energy_performance_preference,
        eax,
        ThermalPowerFeaturesEax::HWP_ENERGY_PERFORMANCE_PREFERENCE
    );

    check_flag!(
        doc = "HWP Package Level Request. IA32_HWP_REQUEST_PKG MSR is supported if set.",
        has_hwp_package_level_request,
        eax,
        ThermalPowerFeaturesEax::HWP_PACKAGE_LEVEL_REQUEST
    );

    check_flag!(
        doc = "HDC. HDC base registers IA32_PKG_HDC_CTL, IA32_PM_CTL1, IA32_THREAD_STALL \
               MSRs are supported if set.",
        has_hdc,
        eax,
        ThermalPowerFeaturesEax::HDC
    );

    check_flag!(
        doc = "Intel® Turbo Boost Max Technology 3.0 available.",
        has_turbo_boost3,
        eax,
        ThermalPowerFeaturesEax::TURBO_BOOST_3
    );

    check_flag!(
        doc = "HWP Capabilities. Highest Performance change is supported if set.",
        has_hwp_capabilities,
        eax,
        ThermalPowerFeaturesEax::HWP_CAPABILITIES
    );

    check_flag!(
        doc = "HWP PECI override is supported if set.",
        has_hwp_peci_override,
        eax,
        ThermalPowerFeaturesEax::HWP_PECI_OVERRIDE
    );

    check_flag!(
        doc = "Flexible HWP is supported if set.",
        has_flexible_hwp,
        eax,
        ThermalPowerFeaturesEax::FLEXIBLE_HWP
    );

    check_flag!(
        doc = "Fast access mode for the IA32_HWP_REQUEST MSR is supported if set.",
        has_hwp_fast_access_mode,
        eax,
        ThermalPowerFeaturesEax::HWP_REQUEST_MSR_FAST_ACCESS
    );

    check_flag!(
        doc = "Ignoring Idle Logical Processor HWP request is supported if set.",
        has_ignore_idle_processor_hwp_request,
        eax,
        ThermalPowerFeaturesEax::IGNORE_IDLE_PROCESSOR_HWP_REQUEST
    );

    check_flag!(
        doc = "Hardware Coordination Feedback Capability (Presence of IA32_MPERF and \
               IA32_APERF). The capability to provide a measure of delivered processor \
               performance (since last reset of the counters), as a percentage of \
               expected processor performance at frequency specified in CPUID Brand \
               String Bits 02 - 01",
        has_hw_coord_feedback,
        ecx,
        ThermalPowerFeaturesEcx::HW_COORD_FEEDBACK
    );

    check_flag!(
        doc = "The processor supports performance-energy bias preference if \
               CPUID.06H:ECX.SETBH[bit 3] is set and it also implies the presence of a \
               new architectural MSR called IA32_ENERGY_PERF_BIAS (1B0H)",
        has_energy_bias_pref,
        ecx,
        ThermalPowerFeaturesEcx::ENERGY_BIAS_PREF
    );
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ThermalPowerFeaturesEax: u32 {
        /// Digital temperature sensor is supported if set. (Bit 00)
        const DTS = 1 << 0;
        /// Intel Turbo Boost Technology Available (see description of IA32_MISC_ENABLE[38]). (Bit 01)
        const TURBO_BOOST = 1 << 1;
        /// ARAT. APIC-Timer-always-running feature is supported if set. (Bit 02)
        const ARAT = 1 << 2;
        /// Bit 3: Reserved.
        const RESERVED_3 = 1 << 3;
        /// PLN. Power limit notification controls are supported if set. (Bit 04)
        const PLN = 1 << 4;
        /// ECMD. Clock modulation duty cycle extension is supported if set. (Bit 05)
        const ECMD = 1 << 5;
        /// PTM. Package thermal management is supported if set. (Bit 06)
        const PTM = 1 << 6;
        /// Bit 07: HWP. HWP base registers (IA32_PM_ENABLE[bit 0], IA32_HWP_CAPABILITIES, IA32_HWP_REQUEST, IA32_HWP_STATUS) are supported if set.
        const HWP = 1 << 7;
        /// Bit 08: HWP_Notification. IA32_HWP_INTERRUPT MSR is supported if set.
        const HWP_NOTIFICATION = 1 << 8;
        /// Bit 09: HWP_Activity_Window. IA32_HWP_REQUEST[bits 41:32] is supported if set.
        const HWP_ACTIVITY_WINDOW = 1 << 9;
        /// Bit 10: HWP_Energy_Performance_Preference. IA32_HWP_REQUEST[bits 31:24] is supported if set.
        const HWP_ENERGY_PERFORMANCE_PREFERENCE = 1 << 10;
        /// Bit 11: HWP_Package_Level_Request. IA32_HWP_REQUEST_PKG MSR is supported if set.
        const HWP_PACKAGE_LEVEL_REQUEST = 1 << 11;
        /// Bit 12: Reserved.
        const RESERVED_12 = 1 << 12;
        /// Bit 13: HDC. HDC base registers IA32_PKG_HDC_CTL, IA32_PM_CTL1, IA32_THREAD_STALL MSRs are supported if set.
        const HDC = 1 << 13;
        /// Bit 14: Intel® Turbo Boost Max Technology 3.0 available.
        const TURBO_BOOST_3 = 1 << 14;
        /// Bit 15: HWP Capabilities. Highest Performance change is supported if set.
        const HWP_CAPABILITIES = 1 << 15;
        /// Bit 16: HWP PECI override is supported if set.
        const HWP_PECI_OVERRIDE = 1 << 16;
        /// Bit 17: Flexible HWP is supported if set.
        const FLEXIBLE_HWP = 1 << 17;
        /// Bit 18: Fast access mode for the IA32_HWP_REQUEST MSR is supported if set.
        const HWP_REQUEST_MSR_FAST_ACCESS = 1 << 18;
        /// Bit 19: Reserved.
        const RESERVED_19 = 1 << 19;
        /// Bit 20: Ignoring Idle Logical Processor HWP request is supported if set.
        const IGNORE_IDLE_PROCESSOR_HWP_REQUEST = 1 << 20;
        // Bits 31 - 21: Reserved
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ThermalPowerFeaturesEcx: u32 {
        /// Hardware Coordination Feedback Capability (Presence of IA32_MPERF and IA32_APERF). The capability to provide a measure of delivered processor performance (since last reset of the counters), as a percentage of expected processor performance at frequency specified in CPUID Brand String Bits 02 - 01
        const HW_COORD_FEEDBACK = 1 << 0;

        /// The processor supports performance-energy bias preference if CPUID.06H:ECX.SETBH[bit 3] is set and it also implies the presence of a new architectural MSR called IA32_ENERGY_PERF_BIAS (1B0H)
        const ENERGY_BIAS_PREF = 1 << 3;
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ExtendedFeatures {
    eax: u32,
    ebx: ExtendedFeaturesEbx,
    ecx: ExtendedFeaturesEcx,
    edx: u32,
}

impl ExtendedFeatures {
    check_flag!(
        doc = "FSGSBASE. Supports RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE if 1.",
        has_fsgsbase,
        ebx,
        ExtendedFeaturesEbx::FSGSBASE
    );

    check_flag!(
        doc = "IA32_TSC_ADJUST MSR is supported if 1.",
        has_tsc_adjust_msr,
        ebx,
        ExtendedFeaturesEbx::ADJUST_MSR
    );

    check_flag!(doc = "BMI1", has_bmi1, ebx, ExtendedFeaturesEbx::BMI1);

    check_flag!(doc = "HLE", has_hle, ebx, ExtendedFeaturesEbx::HLE);

    check_flag!(doc = "AVX2", has_avx2, ebx, ExtendedFeaturesEbx::AVX2);

    check_flag!(
        doc = "FDP_EXCPTN_ONLY. x87 FPU Data Pointer updated only on x87 exceptions if 1.",
        has_fdp,
        ebx,
        ExtendedFeaturesEbx::FDP
    );

    check_flag!(
        doc = "SMEP. Supports Supervisor-Mode Execution Prevention if 1.",
        has_smep,
        ebx,
        ExtendedFeaturesEbx::SMEP
    );

    check_flag!(doc = "BMI2", has_bmi2, ebx, ExtendedFeaturesEbx::BMI2);

    check_flag!(
        doc = "Supports Enhanced REP MOVSB/STOSB if 1.",
        has_rep_movsb_stosb,
        ebx,
        ExtendedFeaturesEbx::REP_MOVSB_STOSB
    );

    check_flag!(
        doc = "INVPCID. If 1, supports INVPCID instruction for system software that \
               manages process-context identifiers.",
        has_invpcid,
        ebx,
        ExtendedFeaturesEbx::INVPCID
    );

    check_flag!(doc = "RTM", has_rtm, ebx, ExtendedFeaturesEbx::RTM);

    check_flag!(
        doc = "Supports Intel Resource Director Technology (RDT) Monitoring capability.",
        has_rdtm,
        ebx,
        ExtendedFeaturesEbx::RDTM
    );

    check_flag!(
        doc = "Deprecates FPU CS and FPU DS values if 1.",
        has_fpu_cs_ds_deprecated,
        ebx,
        ExtendedFeaturesEbx::DEPRECATE_FPU_CS_DS
    );

    check_flag!(
        doc = "MPX. Supports Intel Memory Protection Extensions if 1.",
        has_mpx,
        ebx,
        ExtendedFeaturesEbx::MPX
    );

    check_flag!(
        doc = "Supports Intel Resource Director Technology (RDT) Allocation capability.",
        has_rdta,
        ebx,
        ExtendedFeaturesEbx::RDTA
    );

    check_flag!(
        doc = "Supports RDSEED.",
        has_rdseed,
        ebx,
        ExtendedFeaturesEbx::RDSEED
    );

    #[deprecated(
        since = "3.2",
        note = "Deprecated due to typo in name, users should use has_rdseed() instead."
    )]
    check_flag!(
        doc = "Supports RDSEED (deprecated alias).",
        has_rdseet,
        ebx,
        ExtendedFeaturesEbx::RDSEED
    );

    check_flag!(
        doc = "Supports ADX.",
        has_adx,
        ebx,
        ExtendedFeaturesEbx::ADX
    );

    check_flag!(doc = "SMAP. Supports Supervisor-Mode Access Prevention (and the CLAC/STAC instructions) if 1.",
                has_smap,
                ebx,
                ExtendedFeaturesEbx::SMAP);

    check_flag!(
        doc = "Supports CLFLUSHOPT.",
        has_clflushopt,
        ebx,
        ExtendedFeaturesEbx::CLFLUSHOPT
    );

    check_flag!(
        doc = "Supports Intel Processor Trace.",
        has_processor_trace,
        ebx,
        ExtendedFeaturesEbx::PROCESSOR_TRACE
    );

    check_flag!(
        doc = "Supports SHA Instructions.",
        has_sha,
        ebx,
        ExtendedFeaturesEbx::SHA
    );

    check_flag!(
        doc = "Supports Intel® Software Guard Extensions (Intel® SGX Extensions).",
        has_sgx,
        ebx,
        ExtendedFeaturesEbx::SGX
    );

    check_flag!(
        doc = "Supports AVX512F.",
        has_avx512f,
        ebx,
        ExtendedFeaturesEbx::AVX512F
    );

    check_flag!(
        doc = "Supports AVX512DQ.",
        has_avx512dq,
        ebx,
        ExtendedFeaturesEbx::AVX512DQ
    );

    check_flag!(
        doc = "AVX512_IFMA",
        has_avx512_ifma,
        ebx,
        ExtendedFeaturesEbx::AVX512_IFMA
    );

    check_flag!(
        doc = "AVX512PF",
        has_avx512pf,
        ebx,
        ExtendedFeaturesEbx::AVX512PF
    );
    check_flag!(
        doc = "AVX512ER",
        has_avx512er,
        ebx,
        ExtendedFeaturesEbx::AVX512ER
    );

    check_flag!(
        doc = "AVX512CD",
        has_avx512cd,
        ebx,
        ExtendedFeaturesEbx::AVX512CD
    );

    check_flag!(
        doc = "AVX512BW",
        has_avx512bw,
        ebx,
        ExtendedFeaturesEbx::AVX512BW
    );

    check_flag!(
        doc = "AVX512VL",
        has_avx512vl,
        ebx,
        ExtendedFeaturesEbx::AVX512VL
    );

    check_flag!(doc = "CLWB", has_clwb, ebx, ExtendedFeaturesEbx::CLWB);

    check_flag!(
        doc = "Has PREFETCHWT1 (Intel® Xeon Phi™ only).",
        has_prefetchwt1,
        ecx,
        ExtendedFeaturesEcx::PREFETCHWT1
    );

    check_flag!(
        doc = "Supports user-mode instruction prevention if 1.",
        has_umip,
        ecx,
        ExtendedFeaturesEcx::UMIP
    );

    check_flag!(
        doc = "Supports protection keys for user-mode pages.",
        has_pku,
        ecx,
        ExtendedFeaturesEcx::PKU
    );

    check_flag!(
        doc = "OS has set CR4.PKE to enable protection keys (and the RDPKRU/WRPKRU instructions.",
        has_ospke,
        ecx,
        ExtendedFeaturesEcx::OSPKE
    );

    check_flag!(
        doc = "RDPID and IA32_TSC_AUX are available.",
        has_rdpid,
        ecx,
        ExtendedFeaturesEcx::RDPID
    );

    check_flag!(
        doc = "Supports SGX Launch Configuration.",
        has_sgx_lc,
        ecx,
        ExtendedFeaturesEcx::SGX_LC
    );

    /// The value of MAWAU used by the BNDLDX and BNDSTX instructions in 64-bit mode.
    pub fn mawau_value(&self) -> u8 {
        get_bits(self.ecx.bits(), 17, 21) as u8
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ExtendedFeaturesEbx: u32 {
        /// FSGSBASE. Supports RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE if 1. (Bit 00)
        const FSGSBASE = 1 << 0;
        /// IA32_TSC_ADJUST MSR is supported if 1. (Bit 01)
        const ADJUST_MSR = 1 << 1;
        /// Bit 02: SGX. Supports Intel® Software Guard Extensions (Intel® SGX Extensions) if 1.
        const SGX = 1 << 2;
        /// BMI1 (Bit 03)
        const BMI1 = 1 << 3;
        /// HLE (Bit 04)
        const HLE = 1 << 4;
        /// AVX2 (Bit 05)
        const AVX2 = 1 << 5;
        /// FDP_EXCPTN_ONLY. x87 FPU Data Pointer updated only on x87 exceptions if 1.
        const FDP = 1 << 6;
        /// SMEP. Supports Supervisor-Mode Execution Prevention if 1. (Bit 07)
        const SMEP = 1 << 7;
        /// BMI2 (Bit 08)
        const BMI2 = 1 << 8;
        /// Supports Enhanced REP MOVSB/STOSB if 1. (Bit 09)
        const REP_MOVSB_STOSB = 1 << 9;
        /// INVPCID. If 1, supports INVPCID instruction for system software that manages process-context identifiers. (Bit 10)
        const INVPCID = 1 << 10;
        /// RTM (Bit 11)
        const RTM = 1 << 11;
        /// Supports Intel Resource Director Technology (RDT) Monitoring. (Bit 12)
        const RDTM = 1 << 12;
        /// Deprecates FPU CS and FPU DS values if 1. (Bit 13)
        const DEPRECATE_FPU_CS_DS = 1 << 13;
        /// Deprecates FPU CS and FPU DS values if 1. (Bit 14)
        const MPX = 1 << 14;
        /// Supports Intel Resource Director Technology (RDT) Allocation capability if 1.
        const RDTA = 1 << 15;
        /// Bit 16: AVX512F.
        const AVX512F = 1 << 16;
        /// Bit 17: AVX512DQ.
        const AVX512DQ = 1 << 17;
        /// Supports RDSEED.
        const RDSEED = 1 << 18;
        /// Supports ADX.
        const ADX = 1 << 19;
        /// SMAP. Supports Supervisor-Mode Access Prevention (and the CLAC/STAC instructions) if 1.
        const SMAP = 1 << 20;
        /// Bit 21: AVX512_IFMA.
        const AVX512_IFMA = 1 << 21;
        // Bit 22: Reserved.
        /// Bit 23: CLFLUSHOPT
        const CLFLUSHOPT = 1 << 23;
        /// Bit 24: CLWB.
        const CLWB = 1 << 24;
        /// Bit 25: Intel Processor Trace
        const PROCESSOR_TRACE = 1 << 25;
        /// Bit 26: AVX512PF. (Intel® Xeon Phi™ only.)
        const AVX512PF = 1 << 26;
        /// Bit 27: AVX512ER. (Intel® Xeon Phi™ only.)
        const AVX512ER = 1 << 27;
        /// Bit 28: AVX512CD.
        const AVX512CD = 1 << 28;
        /// Bit 29: Intel SHA Extensions
        const SHA = 1 << 29;
        /// Bit 30: AVX512BW.
        const AVX512BW = 1 << 30;
        /// Bit 31: AVX512VL.
        const AVX512VL = 1 << 31;
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ExtendedFeaturesEcx: u32 {
        /// Bit 0: Prefetch WT1. (Intel® Xeon Phi™ only).
        const PREFETCHWT1 = 1 << 0;

        // Bit 01: AVX512_VBMI
        const AVX512VBMI = 1 << 1;

        /// Bit 02: UMIP. Supports user-mode instruction prevention if 1.
        const UMIP = 1 << 2;

        /// Bit 03: PKU. Supports protection keys for user-mode pages if 1.
        const PKU = 1 << 3;

        /// Bit 04: OSPKE. If 1, OS has set CR4.PKE to enable protection keys (and the RDPKRU/WRPKRU instruc-tions).
        const OSPKE = 1 << 4;

        // Bits 16 - 5: Reserved.
        // Bits 21 - 17: The value of MAWAU used by the BNDLDX and BNDSTX instructions in 64-bit mode.


        /// Bit 22: RDPID. RDPID and IA32_TSC_AUX are available if 1.
        const RDPID = 1 << 22;

        // Bits 29 - 23: Reserved.

        /// Bit 30: SGX_LC. Supports SGX Launch Configuration if 1.
        const SGX_LC = 1 << 30;
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct DirectCacheAccessInfo {
    eax: u32,
}

impl DirectCacheAccessInfo {
    /// Value of bits \[31:0\] of IA32_PLATFORM_DCA_CAP MSR (address 1F8H)
    pub fn get_dca_cap_value(&self) -> u32 {
        self.eax
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct PerformanceMonitoringInfo {
    eax: u32,
    ebx: PerformanceMonitoringFeaturesEbx,
    ecx: u32,
    edx: u32,
}

impl PerformanceMonitoringInfo {
    /// Version ID of architectural performance monitoring. (Bits 07 - 00)
    pub fn version_id(&self) -> u8 {
        get_bits(self.eax, 0, 7) as u8
    }

    /// Number of general-purpose performance monitoring counter per logical processor. (Bits 15- 08)
    pub fn number_of_counters(&self) -> u8 {
        get_bits(self.eax, 8, 15) as u8
    }

    /// Bit width of general-purpose, performance monitoring counter. (Bits 23 - 16)
    pub fn counter_bit_width(&self) -> u8 {
        get_bits(self.eax, 16, 23) as u8
    }

    /// Length of EBX bit vector to enumerate architectural performance monitoring events. (Bits 31 - 24)
    pub fn ebx_length(&self) -> u8 {
        get_bits(self.eax, 24, 31) as u8
    }

    /// Number of fixed-function performance counters (if Version ID > 1). (Bits 04 - 00)
    pub fn fixed_function_counters(&self) -> u8 {
        get_bits(self.edx, 0, 4) as u8
    }

    /// Bit width of fixed-function performance counters (if Version ID > 1). (Bits 12- 05)
    pub fn fixed_function_counters_bit_width(&self) -> u8 {
        get_bits(self.edx, 5, 12) as u8
    }

    check_bit_fn!(
        doc = "AnyThread deprecation",
        has_any_thread_deprecation,
        edx,
        15
    );

    check_flag!(
        doc = "Core cycle event not available if 1.",
        is_core_cyc_ev_unavailable,
        ebx,
        PerformanceMonitoringFeaturesEbx::CORE_CYC_EV_UNAVAILABLE
    );

    check_flag!(
        doc = "Instruction retired event not available if 1.",
        is_inst_ret_ev_unavailable,
        ebx,
        PerformanceMonitoringFeaturesEbx::INST_RET_EV_UNAVAILABLE
    );

    check_flag!(
        doc = "Reference cycles event not available if 1.",
        is_ref_cycle_ev_unavailable,
        ebx,
        PerformanceMonitoringFeaturesEbx::REF_CYC_EV_UNAVAILABLE
    );

    check_flag!(
        doc = "Last-level cache reference event not available if 1.",
        is_cache_ref_ev_unavailable,
        ebx,
        PerformanceMonitoringFeaturesEbx::CACHE_REF_EV_UNAVAILABLE
    );

    check_flag!(
        doc = "Last-level cache misses event not available if 1.",
        is_ll_cache_miss_ev_unavailable,
        ebx,
        PerformanceMonitoringFeaturesEbx::LL_CACHE_MISS_EV_UNAVAILABLE
    );

    check_flag!(
        doc = "Branch instruction retired event not available if 1.",
        is_branch_inst_ret_ev_unavailable,
        ebx,
        PerformanceMonitoringFeaturesEbx::BRANCH_INST_RET_EV_UNAVAILABLE
    );

    check_flag!(
        doc = "Branch mispredict retired event not available if 1.",
        is_branch_midpred_ev_unavailable,
        ebx,
        PerformanceMonitoringFeaturesEbx::BRANCH_MISPRED_EV_UNAVAILABLE
    );
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct PerformanceMonitoringFeaturesEbx: u32 {
        /// Core cycle event not available if 1. (Bit 0)
        const CORE_CYC_EV_UNAVAILABLE = 1 << 0;
        /// Instruction retired event not available if 1. (Bit 01)
        const INST_RET_EV_UNAVAILABLE = 1 << 1;
        /// Reference cycles event not available if 1. (Bit 02)
        const REF_CYC_EV_UNAVAILABLE = 1 << 2;
        /// Last-level cache reference event not available if 1. (Bit 03)
        const CACHE_REF_EV_UNAVAILABLE = 1 << 3;
        /// Last-level cache misses event not available if 1. (Bit 04)
        const LL_CACHE_MISS_EV_UNAVAILABLE = 1 << 4;
        /// Branch instruction retired event not available if 1. (Bit 05)
        const BRANCH_INST_RET_EV_UNAVAILABLE = 1 << 5;
        /// Branch mispredict retired event not available if 1. (Bit 06)
        const BRANCH_MISPRED_EV_UNAVAILABLE = 1 << 6;
    }
}

/// Iterates over the system topology in order to retrieve more
/// system information at each level of the topology.
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ExtendedTopologyIter {
    level: u32,
}

/// Gives detailed information about the current level in the topology
/// (how many cores, what type etc.).
#[derive(Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ExtendedTopologyLevel {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl fmt::Debug for ExtendedTopologyLevel {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_struct("ExtendedTopologyLevel")
            .field("processors", &self.processors())
            .field("number", &self.level_number())
            .field("type", &self.level_type())
            .field("x2apic_id", &self.x2apic_id())
            .field("next_apic_id", &self.shift_right_for_next_apic_id())
            .finish()
    }
}

impl ExtendedTopologyLevel {
    /// Number of logical processors at this level type.
    /// The number reflects configuration as shipped.
    pub fn processors(&self) -> u16 {
        get_bits(self.ebx, 0, 15) as u16
    }

    /// Level number.
    pub fn level_number(&self) -> u8 {
        get_bits(self.ecx, 0, 7) as u8
    }

    // Level type.
    pub fn level_type(&self) -> TopologyType {
        match get_bits(self.ecx, 8, 15) {
            0 => TopologyType::Invalid,
            1 => TopologyType::SMT,
            2 => TopologyType::Core,
            _ => unreachable!(),
        }
    }

    /// x2APIC ID the current logical processor. (Bits 31-00)
    pub fn x2apic_id(&self) -> u32 {
        self.edx
    }

    /// Number of bits to shift right on x2APIC ID to get a unique topology ID of the next level type. (Bits 04-00)
    /// All logical processors with the same next level ID share current level.
    pub fn shift_right_for_next_apic_id(&self) -> u32 {
        get_bits(self.eax, 0, 4)
    }
}

/// What type of core we have at this level in the topology (real CPU or hyper-threaded).
#[derive(PartialEq, Eq, Debug)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub enum TopologyType {
    Invalid = 0,
    /// Hyper-thread (Simultaneous multithreading)
    SMT = 1,
    Core = 2,
}

impl Default for TopologyType {
    fn default() -> TopologyType {
        TopologyType::Invalid
    }
}

impl Iterator for ExtendedTopologyIter {
    type Item = ExtendedTopologyLevel;

    fn next(&mut self) -> Option<ExtendedTopologyLevel> {
        let res = cpuid!(EAX_EXTENDED_TOPOLOGY_INFO, self.level);
        self.level += 1;

        let et = ExtendedTopologyLevel {
            eax: res.eax,
            ebx: res.ebx,
            ecx: res.ecx,
            edx: res.edx,
        };

        match et.level_type() {
            TopologyType::Invalid => None,
            _ => Some(et),
        }
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ExtendedStateInfoXCR0Flags: u32 {
        /// legacy x87 (Bit 00).
        const LEGACY_X87 = 1 << 0;

        /// 128-bit SSE (Bit 01).
        const SSE128 = 1 << 1;

        /// 256-bit AVX (Bit 02).
        const AVX256 = 1 << 2;

        /// MPX BNDREGS (Bit 03).
        const MPX_BNDREGS = 1 << 3;

        /// MPX BNDCSR (Bit 04).
        const MPX_BNDCSR = 1 << 4;

        /// AVX512 OPMASK (Bit 05).
        const AVX512_OPMASK = 1 << 5;

        /// AVX ZMM Hi256 (Bit 06).
        const AVX512_ZMM_HI256 = 1 << 6;

        /// AVX 512 ZMM Hi16 (Bit 07).
        const AVX512_ZMM_HI16 = 1 << 7;

        /// PKRU state (Bit 09).
        const PKRU = 1 << 9;

        /// IA32_XSS HDC State (Bit 13).
        const IA32_XSS_HDC = 1 << 13;
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ExtendedStateInfoXSSFlags: u32 {
        /// IA32_XSS PT (Trace Packet) State (Bit 08).
        const PT = 1 << 8;

        /// IA32_XSS HDC State (Bit 13).
        const HDC = 1 << 13;
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ExtendedStateInfo {
    eax: ExtendedStateInfoXCR0Flags,
    ebx: u32,
    ecx: u32,
    edx: u32,
    eax1: u32,
    ebx1: u32,
    ecx1: ExtendedStateInfoXSSFlags,
    edx1: u32,
}

impl ExtendedStateInfo {
    check_flag!(
        doc = "Support for legacy x87 in XCR0.",
        xcr0_supports_legacy_x87,
        eax,
        ExtendedStateInfoXCR0Flags::LEGACY_X87
    );

    check_flag!(
        doc = "Support for SSE 128-bit in XCR0.",
        xcr0_supports_sse_128,
        eax,
        ExtendedStateInfoXCR0Flags::SSE128
    );

    check_flag!(
        doc = "Support for AVX 256-bit in XCR0.",
        xcr0_supports_avx_256,
        eax,
        ExtendedStateInfoXCR0Flags::AVX256
    );

    check_flag!(
        doc = "Support for MPX BNDREGS in XCR0.",
        xcr0_supports_mpx_bndregs,
        eax,
        ExtendedStateInfoXCR0Flags::MPX_BNDREGS
    );

    check_flag!(
        doc = "Support for MPX BNDCSR in XCR0.",
        xcr0_supports_mpx_bndcsr,
        eax,
        ExtendedStateInfoXCR0Flags::MPX_BNDCSR
    );

    check_flag!(
        doc = "Support for AVX512 OPMASK in XCR0.",
        xcr0_supports_avx512_opmask,
        eax,
        ExtendedStateInfoXCR0Flags::AVX512_OPMASK
    );

    check_flag!(
        doc = "Support for AVX512 ZMM Hi256 XCR0.",
        xcr0_supports_avx512_zmm_hi256,
        eax,
        ExtendedStateInfoXCR0Flags::AVX512_ZMM_HI256
    );

    check_flag!(
        doc = "Support for AVX512 ZMM Hi16 in XCR0.",
        xcr0_supports_avx512_zmm_hi16,
        eax,
        ExtendedStateInfoXCR0Flags::AVX512_ZMM_HI16
    );

    check_flag!(
        doc = "Support for PKRU in XCR0.",
        xcr0_supports_pkru,
        eax,
        ExtendedStateInfoXCR0Flags::PKRU
    );

    check_flag!(
        doc = "Support for PT in IA32_XSS.",
        ia32_xss_supports_pt,
        ecx1,
        ExtendedStateInfoXSSFlags::PT
    );

    check_flag!(
        doc = "Support for HDC in IA32_XSS.",
        ia32_xss_supports_hdc,
        ecx1,
        ExtendedStateInfoXSSFlags::HDC
    );

    /// Maximum size (bytes, from the beginning of the XSAVE/XRSTOR save area) required by
    /// enabled features in XCR0. May be different than ECX if some features at the end of the XSAVE save area
    /// are not enabled.
    pub fn xsave_area_size_enabled_features(&self) -> u32 {
        self.ebx
    }

    /// Maximum size (bytes, from the beginning of the XSAVE/XRSTOR save area) of the
    /// XSAVE/XRSTOR save area required by all supported features in the processor,
    /// i.e all the valid bit fields in XCR0.
    pub fn xsave_area_size_supported_features(&self) -> u32 {
        self.ecx
    }

    /// CPU has xsaveopt feature.
    pub fn has_xsaveopt(&self) -> bool {
        self.eax1 & 0x1 > 0
    }

    /// Supports XSAVEC and the compacted form of XRSTOR if set.
    pub fn has_xsavec(&self) -> bool {
        self.eax1 & 0b10 > 0
    }

    /// Supports XGETBV with ECX = 1 if set.
    pub fn has_xgetbv(&self) -> bool {
        self.eax1 & 0b100 > 0
    }

    /// Supports XSAVES/XRSTORS and IA32_XSS if set.
    pub fn has_xsaves_xrstors(&self) -> bool {
        self.eax1 & 0b1000 > 0
    }

    /// The size in bytes of the XSAVE area containing all states enabled by XCRO | IA32_XSS.
    pub fn xsave_size(&self) -> u32 {
        self.ebx1
    }

    /// Iterator over extended state enumeration levels >= 2.
    pub fn iter(&self) -> ExtendedStateIter {
        ExtendedStateIter {
            level: 1,
            supported_xcr0: self.eax.bits(),
            supported_xss: self.ecx1.bits(),
        }
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ExtendedStateIter {
    level: u32,
    supported_xcr0: u32,
    supported_xss: u32,
}

/// When CPUID executes with EAX set to 0DH and ECX = n (n > 1,
/// and is a valid sub-leaf index), the processor returns information
/// about the size and offset of each processor extended state save area
/// within the XSAVE/XRSTOR area. Software can use the forward-extendable
/// technique depicted below to query the valid sub-leaves and obtain size
/// and offset information for each processor extended state save area:///
///
/// For i = 2 to 62 // sub-leaf 1 is reserved
///   IF (CPUID.(EAX=0DH, ECX=0):VECTOR\[i\] = 1 ) // VECTOR is the 64-bit value of EDX:EAX
///     Execute CPUID.(EAX=0DH, ECX = i) to examine size and offset for sub-leaf i;
/// FI;
impl Iterator for ExtendedStateIter {
    type Item = ExtendedState;

    fn next(&mut self) -> Option<ExtendedState> {
        self.level += 1;
        if self.level > 31 {
            return None;
        }

        let bit = 1 << self.level;
        if (self.supported_xcr0 & bit > 0) || (self.supported_xss & bit > 0) {
            let res = cpuid!(EAX_EXTENDED_STATE_INFO, self.level);
            return Some(ExtendedState {
                subleaf: self.level,
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
            });
        }

        self.next()
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ExtendedState {
    pub subleaf: u32,
    eax: u32,
    ebx: u32,
    ecx: u32,
}

impl ExtendedState {
    /// The size in bytes (from the offset specified in EBX) of the save area
    /// for an extended state feature associated with a valid sub-leaf index, n.
    /// This field reports 0 if the sub-leaf index, n, is invalid.
    pub fn size(&self) -> u32 {
        self.eax
    }

    /// The offset in bytes of this extended state components save area
    /// from the beginning of the XSAVE/XRSTOR area.
    pub fn offset(&self) -> u32 {
        self.ebx
    }

    /// True if the bit n (corresponding to the sub-leaf index)
    /// is supported in the IA32_XSS MSR;
    pub fn is_in_ia32_xss(&self) -> bool {
        self.ecx & 0b1 > 0
    }

    /// True if bit n is supported in XCR0.
    pub fn is_in_xcr0(&self) -> bool {
        self.ecx & 0b1 == 0
    }

    /// Returns true when the compacted format of an XSAVE area is used,
    /// this extended state component located on the next 64-byte
    /// boundary following the preceding state component
    /// (otherwise, it is located immediately following the preceding state component).
    pub fn is_compacted_format(&self) -> bool {
        self.ecx & 0b10 > 0
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct RdtMonitoringInfo {
    ebx: u32,
    edx: u32,
}

/// Intel Resource Director Technology (Intel RDT) Monitoring Enumeration Sub-leaf (EAX = 0FH, ECX = 0 and ECX = 1)
impl RdtMonitoringInfo {
    /// Maximum range (zero-based) of RMID within this physical processor of all types.
    pub fn rmid_range(&self) -> u32 {
        self.ebx
    }

    check_bit_fn!(
        doc = "Supports L3 Cache Intel RDT Monitoring.",
        has_l3_monitoring,
        edx,
        1
    );

    /// L3 Cache Monitoring.
    pub fn l3_monitoring(&self) -> Option<L3MonitoringInfo> {
        if self.has_l3_monitoring() {
            let res = cpuid!(EAX_RDT_MONITORING, 1);
            return Some(L3MonitoringInfo {
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            });
        } else {
            return None;
        }
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct L3MonitoringInfo {
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl L3MonitoringInfo {
    /// Conversion factor from reported IA32_QM_CTR value to occupancy metric (bytes).
    pub fn conversion_factor(&self) -> u32 {
        self.ebx
    }

    /// Maximum range (zero-based) of RMID of L3.
    pub fn maximum_rmid_range(&self) -> u32 {
        self.ecx
    }

    check_bit_fn!(
        doc = "Supports occupancy monitoring.",
        has_occupancy_monitoring,
        edx,
        0
    );

    check_bit_fn!(
        doc = "Supports total bandwidth monitoring.",
        has_total_bandwidth_monitoring,
        edx,
        1
    );

    check_bit_fn!(
        doc = "Supports local bandwidth monitoring.",
        has_local_bandwidth_monitoring,
        edx,
        2
    );
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct RdtAllocationInfo {
    ebx: u32,
}

impl RdtAllocationInfo {
    check_bit_fn!(doc = "Supports L3 Cache Allocation.", has_l3_cat, ebx, 1);

    check_bit_fn!(doc = "Supports L2 Cache Allocation.", has_l2_cat, ebx, 2);

    check_bit_fn!(
        doc = "Supports Memory Bandwidth Allocation.",
        has_memory_bandwidth_allocation,
        ebx,
        1
    );

    /// L3 Cache Allocation Information.
    pub fn l3_cat(&self) -> Option<L3CatInfo> {
        if self.has_l3_cat() {
            let res = cpuid!(EAX_RDT_ALLOCATION, 1);
            return Some(L3CatInfo {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            });
        } else {
            return None;
        }
    }

    /// L2 Cache Allocation Information.
    pub fn l2_cat(&self) -> Option<L2CatInfo> {
        if self.has_l2_cat() {
            let res = cpuid!(EAX_RDT_ALLOCATION, 2);
            return Some(L2CatInfo {
                eax: res.eax,
                ebx: res.ebx,
                edx: res.edx,
            });
        } else {
            return None;
        }
    }

    /// Memory Bandwidth Allocation Information.
    pub fn memory_bandwidth_allocation(&self) -> Option<MemBwAllocationInfo> {
        if self.has_l2_cat() {
            let res = cpuid!(EAX_RDT_ALLOCATION, 3);
            return Some(MemBwAllocationInfo {
                eax: res.eax,
                ecx: res.ecx,
                edx: res.edx,
            });
        } else {
            return None;
        }
    }
}

/// L3 Cache Allocation Technology Enumeration Sub-leaf (EAX = 10H, ECX = ResID = 1).
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct L3CatInfo {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl L3CatInfo {
    /// Length of the capacity bit mask using minus-one notation.
    pub fn capacity_mask_length(&self) -> u8 {
        get_bits(self.eax, 0, 4) as u8
    }

    /// Bit-granular map of isolation/contention of allocation units.
    pub fn isolation_bitmap(&self) -> u32 {
        self.ebx
    }

    /// Highest COS number supported for this Leaf.
    pub fn highest_cos(&self) -> u16 {
        get_bits(self.edx, 0, 15) as u16
    }

    check_bit_fn!(
        doc = "Is Code and Data Prioritization Technology supported?",
        has_code_data_prioritization,
        ecx,
        2
    );
}

/// L2 Cache Allocation Technology Enumeration Sub-leaf (EAX = 10H, ECX = ResID = 2).
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct L2CatInfo {
    eax: u32,
    ebx: u32,
    edx: u32,
}

impl L2CatInfo {
    /// Length of the capacity bit mask using minus-one notation.
    pub fn capacity_mask_length(&self) -> u8 {
        get_bits(self.eax, 0, 4) as u8
    }

    /// Bit-granular map of isolation/contention of allocation units.
    pub fn isolation_bitmap(&self) -> u32 {
        self.ebx
    }

    /// Highest COS number supported for this Leaf.
    pub fn highest_cos(&self) -> u16 {
        get_bits(self.edx, 0, 15) as u16
    }
}

/// Memory Bandwidth Allocation Enumeration Sub-leaf (EAX = 10H, ECX = ResID = 3).
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct MemBwAllocationInfo {
    eax: u32,
    ecx: u32,
    edx: u32,
}

impl MemBwAllocationInfo {
    /// Reports the maximum MBA throttling value supported for the corresponding ResID using minus-one notation.
    pub fn max_hba_throttling(&self) -> u16 {
        get_bits(self.eax, 0, 11) as u16
    }

    /// Highest COS number supported for this Leaf.
    pub fn highest_cos(&self) -> u16 {
        get_bits(self.edx, 0, 15) as u16
    }

    check_bit_fn!(
        doc = "Reports whether the response of the delay values is linear.",
        has_linear_response_delay,
        ecx,
        2
    );
}

/// Intel SGX Capability Enumeration Leaf, sub-leaf 0 (EAX = 12H, ECX = 0 and ECX = 1)
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct SgxInfo {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
    eax1: u32,
    ebx1: u32,
    ecx1: u32,
    edx1: u32,
}

impl SgxInfo {
    check_bit_fn!(doc = "Has SGX1 support.", has_sgx1, eax, 0);
    check_bit_fn!(doc = "Has SGX2 support.", has_sgx2, eax, 1);

    check_bit_fn!(
        doc = "Supports ENCLV instruction leaves EINCVIRTCHILD, EDECVIRTCHILD, and ESETCONTEXT.",
        has_enclv_leaves_einvirtchild_edecvirtchild_esetcontext,
        eax,
        5
    );

    check_bit_fn!(
        doc = "Supports ENCLS instruction leaves ETRACKC, ERDINFO, ELDBC, and ELDUC.",
        has_encls_leaves_etrackc_erdinfo_eldbc_elduc,
        eax,
        6
    );

    /// Bit vector of supported extended SGX features.
    pub fn miscselect(&self) -> u32 {
        self.ebx
    }

    ///  The maximum supported enclave size in non-64-bit mode is 2^retval.
    pub fn max_enclave_size_non_64bit(&self) -> u8 {
        get_bits(self.edx, 0, 7) as u8
    }

    ///  The maximum supported enclave size in 64-bit mode is 2^retval.
    pub fn max_enclave_size_64bit(&self) -> u8 {
        get_bits(self.edx, 8, 15) as u8
    }

    /// Reports the valid bits of SECS.ATTRIBUTES\[127:0\] that software can set with ECREATE.
    pub fn secs_attributes(&self) -> (u64, u64) {
        let lower = self.eax1 as u64 | (self.ebx1 as u64) << 32;
        let upper = self.ecx1 as u64 | (self.edx1 as u64) << 32;
        (lower, upper)
    }
    /// Iterator over SGX sub-leafs.
    pub fn iter(&self) -> SgxSectionIter {
        SgxSectionIter { current: 2 }
    }
}

/// Iterator over the SGX sub-leafs (ECX >= 2).
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct SgxSectionIter {
    current: u32,
}

impl Iterator for SgxSectionIter {
    type Item = SgxSectionInfo;

    fn next(&mut self) -> Option<SgxSectionInfo> {
        self.current += 1;
        let res = cpuid!(EAX_SGX, self.current);
        match get_bits(res.eax, 0, 3) {
            0b0001 => Some(SgxSectionInfo::Epc(EpcSection {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            })),
            _ => None,
        }
    }
}

/// Intel SGX EPC Enumeration Leaf, sub-leaves (EAX = 12H, ECX = 2 or higher)
#[derive(Debug)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub enum SgxSectionInfo {
    // This would be nice: https://github.com/rust-lang/rfcs/pull/1450
    Epc(EpcSection),
}

impl Default for SgxSectionInfo {
    fn default() -> SgxSectionInfo {
        SgxSectionInfo::Epc(Default::default())
    }
}

/// EBX:EAX and EDX:ECX provide information on the Enclave Page Cache (EPC) section
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct EpcSection {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl EpcSection {
    /// The physical address of the base of the EPC section
    pub fn physical_base(&self) -> u64 {
        let lower = (get_bits(self.eax, 12, 31) << 12) as u64;
        let upper = (get_bits(self.ebx, 0, 19) as u64) << 32;
        lower | upper
    }

    /// Size of the corresponding EPC section within the Processor Reserved Memory.
    pub fn size(&self) -> u64 {
        let lower = (get_bits(self.ecx, 12, 31) << 12) as u64;
        let upper = (get_bits(self.edx, 0, 19) as u64) << 32;
        lower | upper
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ProcessorTraceInfo {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
    leaf1: Option<CpuIdResult>,
}

impl ProcessorTraceInfo {
    // EBX features
    check_bit_fn!(
        doc = "If true, Indicates that IA32_RTIT_CTL.CR3Filter can be set to 1, and \
               that IA32_RTIT_CR3_MATCH MSR can be accessed.",
        has_rtit_cr3_match,
        ebx,
        0
    );
    check_bit_fn!(
        doc = "If true, Indicates support of Configurable PSB and Cycle-Accurate Mode.",
        has_configurable_psb_and_cycle_accurate_mode,
        ebx,
        1
    );
    check_bit_fn!(
        doc = "If true, Indicates support of IP Filtering, TraceStop filtering, and \
               preservation of Intel PT MSRs across warm reset.",
        has_ip_tracestop_filtering,
        ebx,
        2
    );
    check_bit_fn!(
        doc = "If true, Indicates support of MTC timing packet and suppression of \
               COFI-based packets.",
        has_mtc_timing_packet_coefi_suppression,
        ebx,
        3
    );

    check_bit_fn!(
        doc = "Indicates support of PTWRITE. Writes can set IA32_RTIT_CTL\\[12\\] (PTWEn \
               and IA32_RTIT_CTL\\[5\\] (FUPonPTW), and PTWRITE can generate packets",
        has_ptwrite,
        ebx,
        4
    );

    check_bit_fn!(
        doc = "Support of Power Event Trace. Writes can set IA32_RTIT_CTL\\[4\\] (PwrEvtEn) \
               enabling Power Event Trace packet generation.",
        has_power_event_trace,
        ebx,
        5
    );

    // ECX features
    check_bit_fn!(
        doc = "If true, Tracing can be enabled with IA32_RTIT_CTL.ToPA = 1, hence \
               utilizing the ToPA output scheme; IA32_RTIT_OUTPUT_BASE and \
               IA32_RTIT_OUTPUT_MASK_PTRS MSRs can be accessed.",
        has_topa,
        ecx,
        0
    );
    check_bit_fn!(
        doc = "If true, ToPA tables can hold any number of output entries, up to the \
               maximum allowed by the MaskOrTableOffset field of \
               IA32_RTIT_OUTPUT_MASK_PTRS.",
        has_topa_maximum_entries,
        ecx,
        1
    );
    check_bit_fn!(
        doc = "If true, Indicates support of Single-Range Output scheme.",
        has_single_range_output_scheme,
        ecx,
        2
    );
    check_bit_fn!(
        doc = "If true, Indicates support of output to Trace Transport subsystem.",
        has_trace_transport_subsystem,
        ecx,
        3
    );
    check_bit_fn!(
        doc = "If true, Generated packets which contain IP payloads have LIP values, \
               which include the CS base component.",
        has_lip_with_cs_base,
        ecx,
        31
    );

    /// Number of configurable Address Ranges for filtering (Bits 2:0).
    pub fn configurable_address_ranges(&self) -> u8 {
        self.leaf1.map_or(0, |res| get_bits(res.eax, 0, 2) as u8)
    }

    /// Bitmap of supported MTC period encodings (Bit 31:16).
    pub fn supported_mtc_period_encodings(&self) -> u16 {
        self.leaf1.map_or(0, |res| get_bits(res.eax, 16, 31) as u16)
    }

    /// Bitmap of supported Cycle Threshold value encodings (Bits 15-0).
    pub fn supported_cycle_threshold_value_encodings(&self) -> u16 {
        self.leaf1.map_or(0, |res| get_bits(res.ebx, 0, 15) as u16)
    }

    /// Bitmap of supported Configurable PSB frequency encodings (Bit 31:16)
    pub fn supported_psb_frequency_encodings(&self) -> u16 {
        self.leaf1.map_or(0, |res| get_bits(res.ebx, 16, 31) as u16)
    }
}

/// Time Stamp Counter and Nominal Core Crystal Clock Information Leaf.
#[derive(Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct TscInfo {
    eax: u32,
    ebx: u32,
    ecx: u32,
}

impl fmt::Debug for TscInfo {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_struct("TscInfo")
            .field("denominator/eax", &self.denominator())
            .field("numerator/ebx", &self.numerator())
            .field("nominal_frequency/ecx", &self.nominal_frequency())
            .finish()
    }
}

impl TscInfo {
    /// An unsigned integer which is the denominator of the TSC/”core crystal clock” ratio.
    pub fn denominator(&self) -> u32 {
        self.eax
    }

    /// An unsigned integer which is the numerator of the TSC/”core crystal clock” ratio.
    ///
    /// If this is 0, the TSC/”core crystal clock” ratio is not enumerated.
    pub fn numerator(&self) -> u32 {
        self.ebx
    }

    /// An unsigned integer which is the nominal frequency of the core crystal clock in Hz.
    ///
    /// If this is 0, the nominal core crystal clock frequency is not enumerated.
    pub fn nominal_frequency(&self) -> u32 {
        self.ecx
    }

    /// “TSC frequency” = “core crystal clock frequency” * EBX/EAX.
    pub fn tsc_frequency(&self) -> u64 {
        self.nominal_frequency() as u64 * self.numerator() as u64 / self.denominator() as u64
    }
}

/// Processor Frequency Information
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ProcessorFrequencyInfo {
    eax: u32,
    ebx: u32,
    ecx: u32,
}

impl ProcessorFrequencyInfo {
    /// Processor Base Frequency (in MHz).
    pub fn processor_base_frequency(&self) -> u16 {
        get_bits(self.eax, 0, 15) as u16
    }

    /// Maximum Frequency (in MHz).
    pub fn processor_max_frequency(&self) -> u16 {
        get_bits(self.ebx, 0, 15) as u16
    }

    /// Bus (Reference) Frequency (in MHz).
    pub fn bus_frequency(&self) -> u16 {
        get_bits(self.ecx, 0, 15) as u16
    }
}

/// Deterministic Address Translation Structure Iterator
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct DatIter {
    current: u32,
    count: u32,
}

impl Iterator for DatIter {
    type Item = DatInfo;

    /// Iterate over each sub-leaf with an  address translation structure.
    fn next(&mut self) -> Option<DatInfo> {
        loop {
            // Sub-leaf index n is invalid if n exceeds the value that sub-leaf 0 returns in EAX
            if self.current > self.count {
                return None;
            }

            let res = cpuid!(EAX_DETERMINISTIC_ADDRESS_TRANSLATION_INFO, self.current);
            self.current += 1;

            // A sub-leaf index is also invalid if EDX[4:0] returns 0.
            if get_bits(res.edx, 0, 4) == 0 {
                // Valid sub-leaves do not need to be contiguous or in any particular order.
                // A valid sub-leaf may be in a higher input ECX value than an invalid sub-leaf
                // or than a valid sub-leaf of a higher or lower-level struc-ture
                continue;
            }

            return Some(DatInfo {
                eax: res.eax,
                ebx: res.ebx,
                ecx: res.ecx,
                edx: res.edx,
            });
        }
    }
}

/// Deterministic Address Translation Structure
#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct DatInfo {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl DatInfo {
    check_bit_fn!(
        doc = "4K page size entries supported by this structure",
        has_4k_entries,
        ebx,
        0
    );

    check_bit_fn!(
        doc = "2MB page size entries supported by this structure",
        has_2mb_entries,
        ebx,
        1
    );

    check_bit_fn!(
        doc = "4MB page size entries supported by this structure",
        has_4mb_entries,
        ebx,
        2
    );

    check_bit_fn!(
        doc = "1GB page size entries supported by this structure",
        has_1gb_entries,
        ebx,
        3
    );

    check_bit_fn!(
        doc = "Fully associative structure",
        is_fully_associative,
        edx,
        8
    );

    /// Partitioning (0: Soft partitioning between the logical processors sharing this structure).
    pub fn partitioning(&self) -> u8 {
        get_bits(self.ebx, 8, 10) as u8
    }

    /// Ways of associativity.
    pub fn ways(&self) -> u16 {
        get_bits(self.ebx, 16, 31) as u16
    }

    /// Number of Sets.
    pub fn sets(&self) -> u32 {
        self.ecx
    }

    /// Translation cache type field.
    pub fn cache_type(&self) -> DatType {
        match get_bits(self.edx, 0, 4) as u8 {
            0b00001 => DatType::DataTLB,
            0b00010 => DatType::InstructionTLB,
            0b00011 => DatType::UnifiedTLB,
            0b00000 => DatType::Null, // should never be returned as this indicates invalid struct!
            _ => DatType::Unknown,
        }
    }

    /// Translation cache level (starts at 1)
    pub fn cache_level(&self) -> u8 {
        get_bits(self.edx, 5, 7) as u8
    }

    /// Maximum number of addressable IDs for logical processors sharing this translation cache
    pub fn max_addressable_ids(&self) -> u16 {
        // Add one to the return value to get the result:
        (get_bits(self.edx, 14, 25) + 1) as u16
    }
}

/// Deterministic Address Translation cache type (EDX bits 04 -- 00)
#[derive(Debug)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub enum DatType {
    /// Null (indicates this sub-leaf is not valid).
    Null = 0b00000,
    DataTLB = 0b00001,
    InstructionTLB = 0b00010,
    /// Some unified TLBs will allow a single TLB entry to satisfy data read/write
    /// and instruction fetches. Others will require separate entries (e.g., one
    /// loaded on data read/write and another loaded on an instruction fetch) .
    /// Please see the Intel® 64 and IA-32 Architectures Optimization Reference Manual
    /// for details of a particular product.
    UnifiedTLB = 0b00011,
    Unknown,
}

impl Default for DatType {
    fn default() -> DatType {
        DatType::Null
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct SoCVendorInfo {
    /// MaxSOCID_Index
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl SoCVendorInfo {
    pub fn get_soc_vendor_id(&self) -> u16 {
        get_bits(self.ebx, 0, 15) as u16
    }

    pub fn get_project_id(&self) -> u32 {
        self.ecx
    }

    pub fn get_stepping_id(&self) -> u32 {
        self.edx
    }

    pub fn get_vendor_brand(&self) -> SoCVendorBrand {
        assert!(self.eax >= 3); // Leaf 17H is valid if MaxSOCID_Index >= 3.
        let r1 = cpuid!(EAX_SOC_VENDOR_INFO, 1);
        let r2 = cpuid!(EAX_SOC_VENDOR_INFO, 2);
        let r3 = cpuid!(EAX_SOC_VENDOR_INFO, 3);
        SoCVendorBrand { data: [r1, r2, r3] }
    }

    pub fn get_vendor_attributes(&self) -> Option<SoCVendorAttributesIter> {
        if self.eax > 3 {
            Some(SoCVendorAttributesIter {
                count: self.eax,
                current: 3,
            })
        } else {
            None
        }
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct SoCVendorAttributesIter {
    count: u32,
    current: u32,
}

impl Iterator for SoCVendorAttributesIter {
    type Item = CpuIdResult;

    /// Iterate over all SoC vendor specific attributes.
    fn next(&mut self) -> Option<CpuIdResult> {
        if self.current > self.count {
            return None;
        }
        self.count += 1;
        Some(cpuid!(EAX_SOC_VENDOR_INFO, self.count))
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct SoCVendorBrand {
    #[allow(dead_code)]
    data: [CpuIdResult; 3],
}

impl SoCVendorBrand {
    pub fn as_string<'a>(&'a self) -> &'a str {
        unsafe {
            let brand_string_start = self as *const SoCVendorBrand as *const u8;
            let slice =
                slice::from_raw_parts(brand_string_start, core::mem::size_of::<SoCVendorBrand>());
            let byte_array: &'a [u8] = transmute(slice);
            str::from_utf8_unchecked(byte_array)
        }
    }
}

impl fmt::Display for SoCVendorBrand {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.as_string())
    }
}

/// Information about Hypervisor (https://lwn.net/Articles/301888/)
pub struct HypervisorInfo {
    res: CpuIdResult,
}

impl fmt::Debug for HypervisorInfo {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_struct("HypervisorInfo")
            .field("type", &self.identify())
            .field("tsc_frequency", &self.tsc_frequency())
            .field("apic_frequency", &self.apic_frequency())
            .finish()
    }
}

/// Identifies the different Hypervisor products.
#[derive(Debug, Eq, PartialEq)]
pub enum Hypervisor {
    Xen,
    VMware,
    HyperV,
    KVM,
    Unknown(u32, u32, u32),
}

impl HypervisorInfo {
    pub fn identify(&self) -> Hypervisor {
        match (self.res.ebx, self.res.ecx, self.res.edx) {
            // "VMwareVMware"
            (0x61774d56, 0x4d566572, 0x65726177) => Hypervisor::VMware,
            // "XenVMMXenVMM"
            (0x566e6558, 0x65584d4d, 0x4d4d566e) => Hypervisor::Xen,
            // "Microsoft Hv"
            (0x7263694d, 0x666f736f, 0x76482074) => Hypervisor::HyperV,
            // "KVMKVMKVM\0\0\0"
            (0x4b4d564b, 0x564b4d56, 0x0000004d) => Hypervisor::KVM,
            (ebx, ecx, edx) => Hypervisor::Unknown(ebx, ecx, edx),
        }
    }

    /// TSC frequency in kHz.
    pub fn tsc_frequency(&self) -> Option<u32> {
        // vm aware tsc frequency retrieval:
        // # EAX: (Virtual) TSC frequency in kHz.
        if self.res.eax >= 0x40000010 {
            let virt_tinfo = cpuid!(0x40000010, 0);
            Some(virt_tinfo.eax)
        } else {
            None
        }
    }

    /// (Virtual) Bus (local apic timer) frequency in kHz.
    pub fn apic_frequency(&self) -> Option<u32> {
        // # EBX: (Virtual) Bus (local apic timer) frequency in kHz.
        if self.res.eax >= 0x40000010 {
            let virt_tinfo = cpuid!(0x40000010, 0);
            Some(virt_tinfo.ebx)
        } else {
            None
        }
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct ExtendedFunctionInfo {
    max_eax_value: u32,
    data: [CpuIdResult; 9],
}

#[derive(PartialEq, Eq, Debug)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub enum L2Associativity {
    Disabled = 0x0,
    DirectMapped = 0x1,
    TwoWay = 0x2,
    FourWay = 0x4,
    EightWay = 0x6,
    SixteenWay = 0x8,
    FullyAssiciative = 0xF,
    Unknown,
}

impl Default for L2Associativity {
    fn default() -> L2Associativity {
        L2Associativity::Unknown
    }
}

const EAX_EXTENDED_PROC_SIGNATURE: u32 = 0x1;
const EAX_EXTENDED_BRAND_STRING: u32 = 0x4;
const EAX_EXTENDED_CACHE_INFO: u32 = 0x6;

impl ExtendedFunctionInfo {
    fn leaf_is_supported(&self, val: u32) -> bool {
        val <= self.max_eax_value
    }

    /// Retrieve processor brand string.
    pub fn processor_brand_string<'a>(&'a self) -> Option<&'a str> {
        if self.leaf_is_supported(EAX_EXTENDED_BRAND_STRING) {
            Some(unsafe {
                let brand_string_start = &self.data[2] as *const CpuIdResult as *const u8;
                let mut slice = slice::from_raw_parts(brand_string_start, 3 * 4 * 4);

                match slice.iter().position(|&x| x == 0) {
                    Some(index) => slice = slice::from_raw_parts(brand_string_start, index),
                    None => (),
                }

                let byte_array: &'a [u8] = transmute(slice);
                str::from_utf8_unchecked(byte_array)
            })
        } else {
            None
        }
    }

    /// Extended Processor Signature and Feature Bits.
    pub fn extended_signature(&self) -> Option<u32> {
        if self.leaf_is_supported(EAX_EXTENDED_PROC_SIGNATURE) {
            Some(self.data[1].eax)
        } else {
            None
        }
    }

    /// Cache Line size in bytes
    pub fn cache_line_size(&self) -> Option<u8> {
        if self.leaf_is_supported(EAX_EXTENDED_CACHE_INFO) {
            Some(get_bits(self.data[6].ecx, 0, 7) as u8)
        } else {
            None
        }
    }

    /// L2 Associativity field
    pub fn l2_associativity(&self) -> Option<L2Associativity> {
        if self.leaf_is_supported(EAX_EXTENDED_CACHE_INFO) {
            Some(match get_bits(self.data[6].ecx, 12, 15) {
                0x0 => L2Associativity::Disabled,
                0x1 => L2Associativity::DirectMapped,
                0x2 => L2Associativity::TwoWay,
                0x4 => L2Associativity::FourWay,
                0x6 => L2Associativity::EightWay,
                0x8 => L2Associativity::SixteenWay,
                0xF => L2Associativity::FullyAssiciative,
                _ => L2Associativity::Unknown,
            })
        } else {
            None
        }
    }

    /// Cache size in 1K units
    pub fn cache_size(&self) -> Option<u16> {
        if self.leaf_is_supported(EAX_EXTENDED_CACHE_INFO) {
            Some(get_bits(self.data[6].ecx, 16, 31) as u16)
        } else {
            None
        }
    }

    /// #Physical Address Bits
    pub fn physical_address_bits(&self) -> Option<u8> {
        if self.leaf_is_supported(8) {
            Some(get_bits(self.data[8].eax, 0, 7) as u8)
        } else {
            None
        }
    }

    /// #Linear Address Bits
    pub fn linear_address_bits(&self) -> Option<u8> {
        if self.leaf_is_supported(8) {
            Some(get_bits(self.data[8].eax, 8, 15) as u8)
        } else {
            None
        }
    }

    /// Is Invariant TSC available?
    pub fn has_invariant_tsc(&self) -> bool {
        self.leaf_is_supported(7) && self.data[7].edx & (1 << 8) > 0
    }

    /// Is LAHF/SAHF available in 64-bit mode?
    pub fn has_lahf_sahf(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEcx {
                bits: self.data[1].ecx,
            }
            .contains(ExtendedFunctionInfoEcx::LAHF_SAHF)
    }

    /// Is LZCNT available?
    pub fn has_lzcnt(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEcx {
                bits: self.data[1].ecx,
            }
            .contains(ExtendedFunctionInfoEcx::LZCNT)
    }

    /// Is PREFETCHW available?
    pub fn has_prefetchw(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEcx {
                bits: self.data[1].ecx,
            }
            .contains(ExtendedFunctionInfoEcx::PREFETCHW)
    }

    /// Are fast system calls available.
    pub fn has_syscall_sysret(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEdx {
                bits: self.data[1].edx,
            }
            .contains(ExtendedFunctionInfoEdx::SYSCALL_SYSRET)
    }

    /// Is there support for execute disable bit.
    pub fn has_execute_disable(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEdx {
                bits: self.data[1].edx,
            }
            .contains(ExtendedFunctionInfoEdx::EXECUTE_DISABLE)
    }

    /// Is there support for 1GiB pages.
    pub fn has_1gib_pages(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEdx {
                bits: self.data[1].edx,
            }
            .contains(ExtendedFunctionInfoEdx::GIB_PAGES)
    }

    /// Check support for rdtscp instruction.
    pub fn has_rdtscp(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEdx {
                bits: self.data[1].edx,
            }
            .contains(ExtendedFunctionInfoEdx::RDTSCP)
    }

    /// Check support for 64-bit mode.
    pub fn has_64bit_mode(&self) -> bool {
        self.leaf_is_supported(1)
            && ExtendedFunctionInfoEdx {
                bits: self.data[1].edx,
            }
            .contains(ExtendedFunctionInfoEdx::I64BIT_MODE)
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ExtendedFunctionInfoEcx: u32 {
        /// LAHF/SAHF available in 64-bit mode.
        const LAHF_SAHF = 1 << 0;
        /// Bit 05: LZCNT
        const LZCNT = 1 << 5;
        /// Bit 08: PREFETCHW
        const PREFETCHW = 1 << 8;
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct ExtendedFunctionInfoEdx: u32 {
        /// SYSCALL/SYSRET available in 64-bit mode (Bit 11).
        const SYSCALL_SYSRET = 1 << 11;
        /// Execute Disable Bit available (Bit 20).
        const EXECUTE_DISABLE = 1 << 20;
        /// 1-GByte pages are available if 1 (Bit 26).
        const GIB_PAGES = 1 << 26;
        /// RDTSCP and IA32_TSC_AUX are available if 1 (Bit 27).
        const RDTSCP = 1 << 27;
        /// Intel ® 64 Architecture available if 1 (Bit 29).
        const I64BIT_MODE = 1 << 29;
    }
}

#[derive(Debug, Default)]
#[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
pub struct MemoryEncryptionInfo {
    eax: MemoryEncryptionInfoEax,
    ebx: u32,
    ecx: u32,
    edx: u32,
}

impl MemoryEncryptionInfo {
    check_flag!(
        doc = "Secure Memory Encryption is supported if set.",
        has_sme,
        eax,
        MemoryEncryptionInfoEax::SME
    );

    check_flag!(
        doc = "Secure Encrypted Virtualization is supported if set.",
        has_sev,
        eax,
        MemoryEncryptionInfoEax::SEV
    );

    check_flag!(
        doc = "The Page Flush MSR is available if set.",
        has_page_flush_msr,
        eax,
        MemoryEncryptionInfoEax::PAGE_FLUSH_MSR
    );

    check_flag!(
        doc = "SEV Encrypted State is supported if set.",
        has_sev_es,
        eax,
        MemoryEncryptionInfoEax::SEV_ES
    );

    pub fn physical_address_reduction(&self) -> u8 {
        get_bits(self.ebx, 6, 11) as u8
    }

    pub fn c_bit_position(&self) -> u8 {
        get_bits(self.ebx, 0, 5) as u8
    }

    pub fn max_encrypted_guests(&self) -> u32 {
        self.ecx
    }

    pub fn min_sev_no_es_asid(&self) -> u32 {
        self.edx
    }
}

bitflags! {
    #[derive(Default)]
    #[cfg_attr(feature = "serialize", derive(Serialize, Deserialize))]
    struct MemoryEncryptionInfoEax: u32 {
        /// Bit 00: SME supported
        const SME = 1 << 0;
        /// Bit 01: SEV supported
        const SEV = 1 << 1;
        /// Bit 02: Page Flush MSR available
        const PAGE_FLUSH_MSR = 1 << 2;
        /// Bit 03: SEV-ES supported
        const SEV_ES = 1 << 3;
    }
}
