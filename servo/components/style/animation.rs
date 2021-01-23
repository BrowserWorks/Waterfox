/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

//! CSS transitions and animations.

// NOTE(emilio): This code isn't really executed in Gecko, but we don't want to
// compile it out so that people remember it exists, thus the cfg'd Sender
// import.

use crate::bezier::Bezier;
use crate::context::SharedStyleContext;
use crate::dom::{OpaqueNode, TElement};
use crate::font_metrics::FontMetricsProvider;
use crate::properties::animated_properties::AnimatedProperty;
use crate::properties::longhands::animation_direction::computed_value::single_value::T as AnimationDirection;
use crate::properties::longhands::animation_play_state::computed_value::single_value::T as AnimationPlayState;
use crate::properties::{self, CascadeMode, ComputedValues, LonghandId};
#[cfg(feature = "servo")]
use crate::properties::LonghandIdSet;
use crate::stylesheets::keyframes_rule::{KeyframesAnimation, KeyframesStep, KeyframesStepValue};
use crate::stylesheets::Origin;
use crate::timer::Timer;
use crate::values::computed::Time;
use crate::values::computed::TimingFunction;
use crate::values::generics::box_::AnimationIterationCount;
use crate::values::generics::easing::{StepPosition, TimingFunction as GenericTimingFunction};
use crate::Atom;
#[cfg(feature = "servo")]
use crossbeam_channel::Sender;
use servo_arc::Arc;
use std::fmt;
#[cfg(feature = "gecko")]
use std::sync::mpsc::Sender;

/// This structure represents a keyframes animation current iteration state.
///
/// If the iteration count is infinite, there's no other state, otherwise we
/// have to keep track the current iteration and the max iteration count.
#[derive(Clone, Debug)]
pub enum KeyframesIterationState {
    /// Infinite iterations, so no need to track a state.
    Infinite,
    /// Current and max iterations.
    Finite(f32, f32),
}

/// This structure represents wether an animation is actually running.
///
/// An animation can be running, or paused at a given time.
#[derive(Clone, Debug)]
pub enum KeyframesRunningState {
    /// This animation is paused. The inner field is the percentage of progress
    /// when it was paused, from 0 to 1.
    Paused(f64),
    /// This animation is actually running.
    Running,
}

/// This structure represents the current keyframe animation state, i.e., the
/// duration, the current and maximum iteration count, and the state (either
/// playing or paused).
// TODO: unify the use of f32/f64 in this file.
#[derive(Clone)]
pub struct KeyframesAnimationState {
    /// The time this animation started at.
    pub started_at: f64,
    /// The duration of this animation.
    pub duration: f64,
    /// The delay of the animation.
    pub delay: f64,
    /// The current iteration state for the animation.
    pub iteration_state: KeyframesIterationState,
    /// Werther this animation is paused.
    pub running_state: KeyframesRunningState,
    /// The declared animation direction of this animation.
    pub direction: AnimationDirection,
    /// The current animation direction. This can only be `normal` or `reverse`.
    pub current_direction: AnimationDirection,
    /// Werther this keyframe animation is outdated due to a restyle.
    pub expired: bool,
    /// The original cascade style, needed to compute the generated keyframes of
    /// the animation.
    pub cascade_style: Arc<ComputedValues>,
}

impl KeyframesAnimationState {
    /// Performs a tick in the animation state, i.e., increments the counter of
    /// the current iteration count, updates times and then toggles the
    /// direction if appropriate.
    ///
    /// Returns true if the animation should keep running.
    pub fn tick(&mut self) -> bool {
        debug!("KeyframesAnimationState::tick");
        debug_assert!(!self.expired);

        self.started_at += self.duration + self.delay;
        match self.running_state {
            // If it's paused, don't update direction or iteration count.
            KeyframesRunningState::Paused(_) => return true,
            KeyframesRunningState::Running => {},
        }

        if let KeyframesIterationState::Finite(ref mut current, ref max) = self.iteration_state {
            *current += 1.0;
            // NB: This prevent us from updating the direction, which might be
            // needed for the correct handling of animation-fill-mode.
            if *current >= *max {
                return false;
            }
        }

        // Update the next iteration direction if applicable.
        match self.direction {
            AnimationDirection::Alternate | AnimationDirection::AlternateReverse => {
                self.current_direction = match self.current_direction {
                    AnimationDirection::Normal => AnimationDirection::Reverse,
                    AnimationDirection::Reverse => AnimationDirection::Normal,
                    _ => unreachable!(),
                };
            },
            _ => {},
        }

        true
    }

    /// Updates the appropiate state from other animation.
    ///
    /// This happens when an animation is re-submitted to layout, presumably
    /// because of an state change.
    ///
    /// There are some bits of state we can't just replace, over all taking in
    /// account times, so here's that logic.
    pub fn update_from_other(&mut self, other: &Self, timer: &Timer) {
        use self::KeyframesRunningState::*;

        debug!(
            "KeyframesAnimationState::update_from_other({:?}, {:?})",
            self, other
        );

        // NB: We shall not touch the started_at field, since we don't want to
        // restart the animation.
        let old_started_at = self.started_at;
        let old_duration = self.duration;
        let old_direction = self.current_direction;
        let old_running_state = self.running_state.clone();
        let old_iteration_state = self.iteration_state.clone();
        *self = other.clone();

        let mut new_started_at = old_started_at;

        // If we're unpausing the animation, fake the start time so we seem to
        // restore it.
        //
        // If the animation keeps paused, keep the old value.
        //
        // If we're pausing the animation, compute the progress value.
        match (&mut self.running_state, old_running_state) {
            (&mut Running, Paused(progress)) => {
                new_started_at = timer.seconds() - (self.duration * progress)
            },
            (&mut Paused(ref mut new), Paused(old)) => *new = old,
            (&mut Paused(ref mut progress), Running) => {
                *progress = (timer.seconds() - old_started_at) / old_duration
            },
            _ => {},
        }

        // Don't update the iteration count, just the iteration limit.
        // TODO: see how changing the limit affects rendering in other browsers.
        // We might need to keep the iteration count even when it's infinite.
        match (&mut self.iteration_state, old_iteration_state) {
            (
                &mut KeyframesIterationState::Finite(ref mut iters, _),
                KeyframesIterationState::Finite(old_iters, _),
            ) => *iters = old_iters,
            _ => {},
        }

        self.current_direction = old_direction;
        self.started_at = new_started_at;
    }
}

impl fmt::Debug for KeyframesAnimationState {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.debug_struct("KeyframesAnimationState")
            .field("started_at", &self.started_at)
            .field("duration", &self.duration)
            .field("delay", &self.delay)
            .field("iteration_state", &self.iteration_state)
            .field("running_state", &self.running_state)
            .field("direction", &self.direction)
            .field("current_direction", &self.current_direction)
            .field("expired", &self.expired)
            .field("cascade_style", &())
            .finish()
    }
}

/// State relating to an animation.
#[derive(Clone, Debug)]
pub enum Animation {
    /// A transition is just a single frame triggered at a time, with a reflow.
    ///
    /// the f64 field is the start time as returned by `time::precise_time_s()`.
    Transition(OpaqueNode, f64, PropertyAnimation),

    /// A keyframes animation is identified by a name, and can have a
    /// node-dependent state (i.e. iteration count, etc.).
    ///
    /// TODO(emilio): The animation object could be refcounted.
    Keyframes(
        OpaqueNode,
        KeyframesAnimation,
        Atom,
        KeyframesAnimationState,
    ),
}

impl Animation {
    /// Whether this animation is expired.
    #[inline]
    pub fn is_expired(&self) -> bool {
        match *self {
            Animation::Transition(..) => false,
            Animation::Keyframes(_, _, _, ref state) => state.expired,
        }
    }

    /// The opaque node that owns the animation.
    #[inline]
    pub fn node(&self) -> &OpaqueNode {
        match *self {
            Animation::Transition(ref node, _, _) => node,
            Animation::Keyframes(ref node, _, _, _) => node,
        }
    }

    /// Whether this animation is a transition.
    #[inline]
    pub fn is_transition(&self) -> bool {
        match *self {
            Animation::Transition(..) => true,
            Animation::Keyframes(..) => false,
        }
    }

    /// Whether this animation has the same end value as another one.
    #[inline]
    pub fn is_transition_with_same_end_value(&self, other_animation: &PropertyAnimation) -> bool {
        match *self {
            Animation::Transition(_, _, ref animation) => {
                animation.has_the_same_end_value_as(other_animation)
            },
            Animation::Keyframes(..) => false,
        }
    }
}

/// Represents an animation for a given property.
#[derive(Clone, Debug)]
pub struct PropertyAnimation {
    /// An `AnimatedProperty` that this `PropertyAnimation` corresponds to.
    property: AnimatedProperty,

    /// The timing function of this `PropertyAnimation`.
    timing_function: TimingFunction,

    /// The duration of this `PropertyAnimation` in seconds.
    pub duration: f64,
}

impl PropertyAnimation {
    /// Returns the given property longhand id.
    pub fn property_id(&self) -> LonghandId {
        self.property.id()
    }

    /// Returns the given property name.
    pub fn property_name(&self) -> &'static str {
        self.property.name()
    }

    fn from_longhand(
        longhand: LonghandId,
        timing_function: TimingFunction,
        duration: Time,
        old_style: &ComputedValues,
        new_style: &ComputedValues,
    ) -> Option<PropertyAnimation> {
        let animated_property = AnimatedProperty::from_longhand(longhand, old_style, new_style)?;

        let property_animation = PropertyAnimation {
            property: animated_property,
            timing_function,
            duration: duration.seconds() as f64,
        };

        if property_animation.does_animate() {
            Some(property_animation)
        } else {
            None
        }
    }

    /// Update the given animation at a given point of progress.
    pub fn update(&self, style: &mut ComputedValues, time: f64) {
        let epsilon = 1. / (200. * self.duration);
        let progress = match self.timing_function {
            GenericTimingFunction::CubicBezier { x1, y1, x2, y2 } => {
                Bezier::new(x1, y1, x2, y2).solve(time, epsilon)
            },
            GenericTimingFunction::Steps(steps, pos) => {
                let mut current_step = (time * (steps as f64)).floor() as i32;

                if pos == StepPosition::Start ||
                    pos == StepPosition::JumpStart ||
                    pos == StepPosition::JumpBoth
                {
                    current_step = current_step + 1;
                }

                // FIXME: We should update current_step according to the "before flag".
                // In order to get the before flag, we have to know the current animation phase
                // and whether the iteration is reversed. For now, we skip this calculation.
                // (i.e. Treat before_flag is unset,)
                // https://drafts.csswg.org/css-easing/#step-timing-function-algo

                if time >= 0.0 && current_step < 0 {
                    current_step = 0;
                }

                let jumps = match pos {
                    StepPosition::JumpBoth => steps + 1,
                    StepPosition::JumpNone => steps - 1,
                    StepPosition::JumpStart |
                    StepPosition::JumpEnd |
                    StepPosition::Start |
                    StepPosition::End => steps,
                };

                if time <= 1.0 && current_step > jumps {
                    current_step = jumps;
                }

                (current_step as f64) / (jumps as f64)
            },
            GenericTimingFunction::Keyword(keyword) => {
                let (x1, x2, y1, y2) = keyword.to_bezier();
                Bezier::new(x1, x2, y1, y2).solve(time, epsilon)
            },
        };

        self.property.update(style, progress);
    }

    #[inline]
    fn does_animate(&self) -> bool {
        self.property.does_animate() && self.duration != 0.0
    }

    /// Whether this animation has the same end value as another one.
    #[inline]
    pub fn has_the_same_end_value_as(&self, other: &Self) -> bool {
        self.property.has_the_same_end_value_as(&other.property)
    }
}

/// Start any new transitions for this node and ensure that any existing transitions
/// that are cancelled are marked as cancelled in the SharedStyleContext. This is
/// at the end of calculating style for a single node.
#[cfg(feature = "servo")]
pub fn update_transitions(
    context: &SharedStyleContext,
    new_animations_sender: &Sender<Animation>,
    opaque_node: OpaqueNode,
    old_style: &ComputedValues,
    new_style: &mut Arc<ComputedValues>,
    expired_transitions: &[PropertyAnimation],
) {
    let mut all_running_animations = context.running_animations.write();
    let previously_running_animations = all_running_animations
        .remove(&opaque_node)
        .unwrap_or_else(Vec::new);

    let properties_that_transition = start_transitions_if_applicable(
        context,
        new_animations_sender,
        opaque_node,
        old_style,
        new_style,
        expired_transitions,
        &previously_running_animations,
    );

    let mut all_cancelled_animations = context.cancelled_animations.write();
    let mut cancelled_animations = all_cancelled_animations
        .remove(&opaque_node)
        .unwrap_or_else(Vec::new);
    let mut running_animations = vec![];

    // For every animation that was running before this style change, we cancel it
    // if the property no longer transitions.
    for running_animation in previously_running_animations.into_iter() {
        if let Animation::Transition(_, _, ref property_animation) = running_animation {
            if !properties_that_transition.contains(property_animation.property_id()) {
                cancelled_animations.push(running_animation);
                continue;
            }
        }
        running_animations.push(running_animation);
    }

    if !cancelled_animations.is_empty() {
        all_cancelled_animations.insert(opaque_node, cancelled_animations);
    }
    if !running_animations.is_empty() {
        all_running_animations.insert(opaque_node, running_animations);
    }
}

/// Kick off any new transitions for this node and return all of the properties that are
/// transitioning. This is at the end of calculating style for a single node.
#[cfg(feature = "servo")]
pub fn start_transitions_if_applicable(
    context: &SharedStyleContext,
    new_animations_sender: &Sender<Animation>,
    opaque_node: OpaqueNode,
    old_style: &ComputedValues,
    new_style: &mut Arc<ComputedValues>,
    expired_transitions: &[PropertyAnimation],
    running_animations: &[Animation],
) -> LonghandIdSet {
    use crate::properties::animated_properties::TransitionPropertyIteration;

    // If the style of this element is display:none, then we don't start any transitions
    // and we cancel any currently running transitions by returning an empty LonghandIdSet.
    if new_style.get_box().clone_display().is_none() {
        return LonghandIdSet::new();
    }

    let mut properties_that_transition = LonghandIdSet::new();
    let transitions: Vec<TransitionPropertyIteration> = new_style.transition_properties().collect();
    for transition in &transitions {
        if properties_that_transition.contains(transition.longhand_id) {
            continue;
        } else {
            properties_that_transition.insert(transition.longhand_id);
        }

        let property_animation = match PropertyAnimation::from_longhand(
            transition.longhand_id,
            new_style
                .get_box()
                .transition_timing_function_mod(transition.index),
            new_style
                .get_box()
                .transition_duration_mod(transition.index),
            old_style,
            Arc::make_mut(new_style),
        ) {
            Some(property_animation) => property_animation,
            None => continue,
        };

        // Set the property to the initial value.
        //
        // NB: get_mut is guaranteed to succeed since we called make_mut()
        // above.
        property_animation.update(Arc::get_mut(new_style).unwrap(), 0.0);

        // Per [1], don't trigger a new transition if the end state for that
        // transition is the same as that of a transition that's expired.
        // [1]: https://drafts.csswg.org/css-transitions/#starting
        debug!("checking {:?} for matching end value", expired_transitions);
        if expired_transitions
            .iter()
            .any(|animation| animation.has_the_same_end_value_as(&property_animation))
        {
            debug!(
                "Not initiating transition for {}, expired transition \
                 found with the same end value",
                property_animation.property_name()
            );
            continue;
        }

        if running_animations
            .iter()
            .any(|animation| animation.is_transition_with_same_end_value(&property_animation))
        {
            debug!(
                "Not initiating transition for {}, running transition \
                 found with the same end value",
                property_animation.property_name()
            );
            continue;
        }

        // Kick off the animation.
        debug!("Kicking off transition of {:?}", property_animation);
        let box_style = new_style.get_box();
        let now = context.timer.seconds();
        let start_time = now + (box_style.transition_delay_mod(transition.index).seconds() as f64);
        new_animations_sender
            .send(Animation::Transition(
                opaque_node,
                start_time,
                property_animation,
            ))
            .unwrap();
    }

    properties_that_transition
}

fn compute_style_for_animation_step<E>(
    context: &SharedStyleContext,
    step: &KeyframesStep,
    previous_style: &ComputedValues,
    style_from_cascade: &Arc<ComputedValues>,
    font_metrics_provider: &dyn FontMetricsProvider,
) -> Arc<ComputedValues>
where
    E: TElement,
{
    match step.value {
        KeyframesStepValue::ComputedValues => style_from_cascade.clone(),
        KeyframesStepValue::Declarations {
            block: ref declarations,
        } => {
            let guard = declarations.read_with(context.guards.author);

            // This currently ignores visited styles, which seems acceptable,
            // as existing browsers don't appear to animate visited styles.
            let computed = properties::apply_declarations::<E, _>(
                context.stylist.device(),
                /* pseudo = */ None,
                previous_style.rules(),
                &context.guards,
                // It's possible to have !important properties in keyframes
                // so we have to filter them out.
                // See the spec issue https://github.com/w3c/csswg-drafts/issues/1824
                // Also we filter our non-animatable properties.
                guard
                    .normal_declaration_iter()
                    .filter(|declaration| declaration.is_animatable())
                    .map(|decl| (decl, Origin::Author)),
                Some(previous_style),
                Some(previous_style),
                Some(previous_style),
                font_metrics_provider,
                CascadeMode::Unvisited {
                    visited_rules: None,
                },
                context.quirks_mode(),
                /* rule_cache = */ None,
                &mut Default::default(),
                /* element = */ None,
            );
            computed
        },
    }
}

/// Triggers animations for a given node looking at the animation property
/// values.
pub fn maybe_start_animations<E>(
    element: E,
    context: &SharedStyleContext,
    new_animations_sender: &Sender<Animation>,
    node: OpaqueNode,
    new_style: &Arc<ComputedValues>,
) -> bool
where
    E: TElement,
{
    let mut had_animations = false;

    let box_style = new_style.get_box();
    for (i, name) in box_style.animation_name_iter().enumerate() {
        let name = match name.as_atom() {
            Some(atom) => atom,
            None => continue,
        };

        debug!("maybe_start_animations: name={}", name);
        let total_duration = box_style.animation_duration_mod(i).seconds();
        if total_duration == 0. {
            continue;
        }

        let anim = match context.stylist.get_animation(name, element) {
            Some(animation) => animation,
            None => continue,
        };

        debug!("maybe_start_animations: animation {} found", name);

        // If this animation doesn't have any keyframe, we can just continue
        // without submitting it to the compositor, since both the first and
        // the second keyframes would be synthetised from the computed
        // values.
        if anim.steps.is_empty() {
            continue;
        }

        let delay = box_style.animation_delay_mod(i).seconds();
        let now = context.timer.seconds();
        let animation_start = now + delay as f64;
        let duration = box_style.animation_duration_mod(i).seconds();
        let iteration_state = match box_style.animation_iteration_count_mod(i) {
            AnimationIterationCount::Infinite => KeyframesIterationState::Infinite,
            AnimationIterationCount::Number(n) => KeyframesIterationState::Finite(0.0, n),
        };

        let animation_direction = box_style.animation_direction_mod(i);

        let initial_direction = match animation_direction {
            AnimationDirection::Normal | AnimationDirection::Alternate => {
                AnimationDirection::Normal
            },
            AnimationDirection::Reverse | AnimationDirection::AlternateReverse => {
                AnimationDirection::Reverse
            },
        };

        let running_state = match box_style.animation_play_state_mod(i) {
            AnimationPlayState::Paused => KeyframesRunningState::Paused(0.),
            AnimationPlayState::Running => KeyframesRunningState::Running,
        };

        new_animations_sender
            .send(Animation::Keyframes(
                node,
                anim.clone(),
                name.clone(),
                KeyframesAnimationState {
                    started_at: animation_start,
                    duration: duration as f64,
                    delay: delay as f64,
                    iteration_state,
                    running_state,
                    direction: animation_direction,
                    current_direction: initial_direction,
                    expired: false,
                    cascade_style: new_style.clone(),
                },
            ))
            .unwrap();
        had_animations = true;
    }

    had_animations
}

/// Returns the kind of animation update that happened.
pub enum AnimationUpdate {
    /// The style was successfully updated, the animation is still running.
    Regular,
    /// A style change canceled this animation.
    AnimationCanceled,
}

/// Updates a single animation and associated style based on the current time.
///
/// FIXME(emilio): This doesn't handle any kind of dynamic change to the
/// animation or transition properties in any reasonable way.
///
/// This should probably be split in two, one from updating animations and
/// transitions in response to a style change (that is,
/// consider_starting_transitions + maybe_start_animations, but handling
/// canceled animations, duration changes, etc, there instead of here), and this
/// function should be only about the style update in response of a transition.
pub fn update_style_for_animation<E>(
    context: &SharedStyleContext,
    animation: &Animation,
    style: &mut Arc<ComputedValues>,
    font_metrics_provider: &dyn FontMetricsProvider,
) -> AnimationUpdate
where
    E: TElement,
{
    debug!("update_style_for_animation: {:?}", animation);
    debug_assert!(!animation.is_expired());

    match *animation {
        Animation::Transition(_, start_time, ref property_animation) => {
            let now = context.timer.seconds();
            let progress = (now - start_time) / (property_animation.duration);
            let progress = progress.min(1.0);
            if progress >= 0.0 {
                property_animation.update(Arc::make_mut(style), progress);
            }
            AnimationUpdate::Regular
        },
        Animation::Keyframes(_, ref animation, ref name, ref state) => {
            let duration = state.duration;
            let started_at = state.started_at;

            let now = match state.running_state {
                KeyframesRunningState::Running => context.timer.seconds(),
                KeyframesRunningState::Paused(progress) => started_at + duration * progress,
            };

            debug_assert!(!animation.steps.is_empty());

            let maybe_index = style
                .get_box()
                .animation_name_iter()
                .position(|animation_name| Some(name) == animation_name.as_atom());

            let index = match maybe_index {
                Some(index) => index,
                None => return AnimationUpdate::AnimationCanceled,
            };

            let total_duration = style.get_box().animation_duration_mod(index).seconds() as f64;
            if total_duration == 0. {
                return AnimationUpdate::AnimationCanceled;
            }

            let mut total_progress = (now - started_at) / total_duration;
            if total_progress < 0. {
                warn!("Negative progress found for animation {:?}", name);
                return AnimationUpdate::Regular;
            }
            if total_progress > 1. {
                total_progress = 1.;
            }

            // Get the target and the last keyframe position.
            let last_keyframe_position;
            let target_keyframe_position;
            match state.current_direction {
                AnimationDirection::Normal => {
                    target_keyframe_position = animation
                        .steps
                        .iter()
                        .position(|step| total_progress as f32 <= step.start_percentage.0);

                    last_keyframe_position = target_keyframe_position
                        .and_then(|pos| if pos != 0 { Some(pos - 1) } else { None })
                        .unwrap_or(0);
                },
                AnimationDirection::Reverse => {
                    target_keyframe_position = animation
                        .steps
                        .iter()
                        .rev()
                        .position(|step| total_progress as f32 <= 1. - step.start_percentage.0)
                        .map(|pos| animation.steps.len() - pos - 1);

                    last_keyframe_position = target_keyframe_position
                        .and_then(|pos| {
                            if pos != animation.steps.len() - 1 {
                                Some(pos + 1)
                            } else {
                                None
                            }
                        })
                        .unwrap_or(animation.steps.len() - 1);
                },
                _ => unreachable!(),
            }

            debug!(
                "update_style_for_animation: keyframe from {:?} to {:?}",
                last_keyframe_position, target_keyframe_position
            );

            let target_keyframe = match target_keyframe_position {
                Some(target) => &animation.steps[target],
                None => return AnimationUpdate::Regular,
            };

            let last_keyframe = &animation.steps[last_keyframe_position];

            let relative_timespan =
                (target_keyframe.start_percentage.0 - last_keyframe.start_percentage.0).abs();
            let relative_duration = relative_timespan as f64 * duration;
            let last_keyframe_ended_at = match state.current_direction {
                AnimationDirection::Normal => {
                    state.started_at + (total_duration * last_keyframe.start_percentage.0 as f64)
                },
                AnimationDirection::Reverse => {
                    state.started_at +
                        (total_duration * (1. - last_keyframe.start_percentage.0 as f64))
                },
                _ => unreachable!(),
            };
            let relative_progress = (now - last_keyframe_ended_at) / relative_duration;

            // TODO: How could we optimise it? Is it such a big deal?
            let from_style = compute_style_for_animation_step::<E>(
                context,
                last_keyframe,
                &**style,
                &state.cascade_style,
                font_metrics_provider,
            );

            // NB: The spec says that the timing function can be overwritten
            // from the keyframe style.
            let mut timing_function = style.get_box().animation_timing_function_mod(index);
            if last_keyframe.declared_timing_function {
                // NB: animation_timing_function can never be empty, always has
                // at least the default value (`ease`).
                timing_function = from_style.get_box().animation_timing_function_at(0);
            }

            let target_style = compute_style_for_animation_step::<E>(
                context,
                target_keyframe,
                &from_style,
                &state.cascade_style,
                font_metrics_provider,
            );

            let mut new_style = (*style).clone();

            for property in animation.properties_changed.iter() {
                debug!(
                    "update_style_for_animation: scanning prop {:?} for animation \"{}\"",
                    property, name
                );
                let animation = PropertyAnimation::from_longhand(
                    property,
                    timing_function,
                    Time::from_seconds(relative_duration as f32),
                    &from_style,
                    &target_style,
                );

                match animation {
                    Some(property_animation) => {
                        debug!(
                            "update_style_for_animation: got property animation for prop {:?}",
                            property
                        );
                        debug!("update_style_for_animation: {:?}", property_animation);
                        property_animation.update(Arc::make_mut(&mut new_style), relative_progress);
                    },
                    None => {
                        debug!(
                            "update_style_for_animation: property animation {:?} not animating",
                            property
                        );
                    },
                }
            }

            debug!(
                "update_style_for_animation: got style change in animation \"{}\"",
                name
            );
            *style = new_style;
            AnimationUpdate::Regular
        },
    }
}
