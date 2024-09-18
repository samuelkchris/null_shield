#ifndef FLUTTER_PLUGIN_NULL_SHIELD_PLUGIN_H_
#define FLUTTER_PLUGIN_NULL_SHIELD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace null_shield {

class NullShieldPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NullShieldPlugin();

  virtual ~NullShieldPlugin();

  // Disallow copy and assign.
  NullShieldPlugin(const NullShieldPlugin&) = delete;
  NullShieldPlugin& operator=(const NullShieldPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace null_shield

#endif  // FLUTTER_PLUGIN_NULL_SHIELD_PLUGIN_H_
