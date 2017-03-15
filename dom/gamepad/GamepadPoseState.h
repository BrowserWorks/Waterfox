
#ifndef mozilla_dom_gamepad_GamepadPoseState_h_
#define mozilla_dom_gamepad_GamepadPoseState_h_

namespace mozilla{
namespace dom{

enum class GamepadCapabilityFlags : uint16_t {
  Cap_None = 0,
  /**
   * Cap_Position is set if the Gamepad is capable of tracking its position.
   */
  Cap_Position = 1 << 1,
  /**
    * Cap_Orientation is set if the Gamepad is capable of tracking its orientation.
    */
  Cap_Orientation = 1 << 2,
  /**
   * Cap_AngularAcceleration is set if the Gamepad is capable of tracking its
   * angular acceleration.
   */
  Cap_AngularAcceleration = 1 << 3,
  /**
   * Cap_LinearAcceleration is set if the Gamepad is capable of tracking its
   * linear acceleration.
   */
  Cap_LinearAcceleration = 1 << 4,
  /**
   * Cap_All used for validity checking during IPC serialization
   */
  Cap_All = (1 << 5) - 1
};

MOZ_MAKE_ENUM_CLASS_BITWISE_OPERATORS(GamepadCapabilityFlags)

struct GamepadPoseState
{
  GamepadCapabilityFlags flags;
  float orientation[4];
  float position[3];
  float angularVelocity[3];
  float angularAcceleration[3];
  float linearVelocity[3];
  float linearAcceleration[3];

  GamepadPoseState()
  {
    Clear();
  }

  bool operator==(const GamepadPoseState& aPose) const
  {
    return flags == aPose.flags
           && orientation[0] == aPose.orientation[0]
           && orientation[1] == aPose.orientation[1]
           && orientation[2] == aPose.orientation[2]
           && orientation[3] == aPose.orientation[3]
           && position[0] == aPose.position[0]
           && position[1] == aPose.position[1]
           && position[2] == aPose.position[2]
           && angularVelocity[0] == aPose.angularVelocity[0]
           && angularVelocity[1] == aPose.angularVelocity[1]
           && angularVelocity[2] == aPose.angularVelocity[2]
           && angularAcceleration[0] == aPose.angularAcceleration[0]
           && angularAcceleration[1] == aPose.angularAcceleration[1]
           && angularAcceleration[2] == aPose.angularAcceleration[2]
           && linearVelocity[0] == aPose.linearVelocity[0]
           && linearVelocity[1] == aPose.linearVelocity[1]
           && linearVelocity[2] == aPose.linearVelocity[2]
           && linearAcceleration[0] == aPose.linearAcceleration[0]
           && linearAcceleration[1] == aPose.linearAcceleration[1]
           && linearAcceleration[2] == aPose.linearAcceleration[2];
  }

  bool operator!=(const GamepadPoseState& aPose) const
  {
    return !(*this == aPose);
  }

  void Clear() {
    memset(this, 0, sizeof(GamepadPoseState));
  }
};

}// namespace dom
}// namespace mozilla

#endif // mozilla_dom_gamepad_GamepadPoseState_h_