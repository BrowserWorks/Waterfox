use rustc_serialize::{Encodable, Encoder};
use rustc_serialize::json::{Json, ToJson};
use std::collections::BTreeMap;

use error::{WebDriverResult, WebDriverError, ErrorStatus};

pub static ELEMENT_KEY: &'static str = "element-6066-11e4-a52e-4f735466cecf";

#[derive(RustcEncodable, PartialEq, Clone, Debug)]
pub struct Date(pub u64);

impl Date {
    pub fn new(timestamp: u64) -> Date {
        Date(timestamp)
    }
}

impl ToJson for Date {
    fn to_json(&self) -> Json {
        let &Date(x) = self;
        x.to_json()
    }
}

#[derive(PartialEq, Clone, Debug)]
pub enum Nullable<T: ToJson> {
    Value(T),
    Null
}

impl<T: ToJson> Nullable<T> {
     pub fn is_null(&self) -> bool {
        match *self {
            Nullable::Value(_) => false,
            Nullable::Null => true
        }
    }

     pub fn is_value(&self) -> bool {
        match *self {
            Nullable::Value(_) => true,
            Nullable::Null => false
        }
    }

    pub fn map<F, U: ToJson>(self, f: F) -> Nullable<U>
        where F: FnOnce(T) -> U {
        match self {
            Nullable::Value(val) => Nullable::Value(f(val)),
            Nullable::Null => Nullable::Null
        }
    }
}

impl<T: ToJson> Nullable<T> {
    //This is not very pretty
    pub fn from_json<F: FnOnce(&Json) -> WebDriverResult<T>>(value: &Json, f: F) -> WebDriverResult<Nullable<T>> {
        if value.is_null() {
            Ok(Nullable::Null)
        } else {
            Ok(Nullable::Value(try!(f(value))))
        }
    }
}

impl<T: ToJson> ToJson for Nullable<T> {
    fn to_json(&self) -> Json {
        match *self {
            Nullable::Value(ref x) => x.to_json(),
            Nullable::Null => Json::Null
        }
    }
}

impl<T: ToJson> Encodable for Nullable<T> {
    fn encode<S: Encoder>(&self, s: &mut S) -> Result<(), S::Error> {
        match *self {
            Nullable::Value(ref x) => x.to_json().encode(s),
            Nullable::Null => s.emit_option_none()
        }
    }
}

impl<T: ToJson> Into<Option<T>> for Nullable<T> {
    fn into(self) -> Option<T> {
        match self {
            Nullable::Value(val) => Some(val),
            Nullable::Null => None
        }
    }
}

impl<T: ToJson> From<Option<T>> for Nullable<T> {
    fn from(option: Option<T>) -> Nullable<T> {
        match option {
            Some(val) => Nullable::Value(val),
            None => Nullable::Null,
        }
    }
}

#[derive(Clone, Debug, PartialEq)]
pub struct WebElement {
    pub id: String
}

impl WebElement {
    pub fn new(id: String) -> WebElement {
        WebElement {
            id: id
        }
    }

    pub fn from_json(data: &Json) -> WebDriverResult<WebElement> {
        let object = try_opt!(data.as_object(),
                              ErrorStatus::InvalidArgument,
                              "Could not convert webelement to object");
        let id_value = try_opt!(object.get(ELEMENT_KEY),
                                ErrorStatus::InvalidArgument,
                                "Could not find webelement key");

        let id = try_opt!(id_value.as_string(),
                          ErrorStatus::InvalidArgument,
                          "Could not convert web element to string").to_string();

        Ok(WebElement::new(id))
    }
}

impl ToJson for WebElement {
    fn to_json(&self) -> Json {
        let mut data = BTreeMap::new();
        data.insert(ELEMENT_KEY.to_string(), self.id.to_json());
        Json::Object(data)
    }
}

impl <T> From<T> for WebElement
    where T: Into<String> {
    fn from(data: T) -> WebElement {
        WebElement::new(data.into())
    }
}

#[derive(PartialEq, Debug)]
pub enum FrameId {
    Short(u16),
    Element(WebElement),
    Null
}

impl FrameId {
    pub fn from_json(data: &Json) -> WebDriverResult<FrameId> {
        match data {
            &Json::U64(x) => {
                if x > u16::max_value() as u64 || x < u16::min_value() as u64 {
                    return Err(WebDriverError::new(ErrorStatus::NoSuchFrame,
                                                   "frame id out of range"))
                };
                Ok(FrameId::Short(x as u16))
            },
            &Json::Null => Ok(FrameId::Null),
            &Json::Object(_) => Ok(FrameId::Element(
                try!(WebElement::from_json(data)))),
            _ => Err(WebDriverError::new(ErrorStatus::NoSuchFrame,
                                         "frame id has unexpected type"))
        }
    }
}

impl ToJson for FrameId {
    fn to_json(&self) -> Json {
        match *self {
            FrameId::Short(x) => {
                Json::U64(x as u64)
            },
            FrameId::Element(ref x) => {
                Json::String(x.id.clone())
            },
            FrameId::Null => {
                Json::Null
            }
        }
    }
}

#[derive(PartialEq)]
pub enum LocatorStrategy {
    CSSSelector,
    LinkText,
    PartialLinkText,
    XPath
}

impl LocatorStrategy {
    pub fn from_json(body: &Json) -> WebDriverResult<LocatorStrategy> {
        match try_opt!(body.as_string(),
                       ErrorStatus::InvalidArgument,
                       "Cound not convert strategy to string") {
            "css selector" => Ok(LocatorStrategy::CSSSelector),
            "link text" => Ok(LocatorStrategy::LinkText),
            "partial link text" => Ok(LocatorStrategy::PartialLinkText),
            "xpath" => Ok(LocatorStrategy::XPath),
            x => Err(WebDriverError::new(ErrorStatus::InvalidArgument,
                                         format!("Unknown locator strategy {}", x)))
        }
    }
}

impl ToJson for LocatorStrategy {
    fn to_json(&self) -> Json {
        Json::String(match *self {
            LocatorStrategy::CSSSelector => "css selector",
            LocatorStrategy::LinkText => "link text",
            LocatorStrategy::PartialLinkText => "partial link text",
            LocatorStrategy::XPath => "xpath"
        }.to_string())
    }
}
