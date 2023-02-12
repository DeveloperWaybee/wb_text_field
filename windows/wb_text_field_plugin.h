#ifndef FLUTTER_PLUGIN_WB_TEXT_FIELD_PLUGIN_H_
#define FLUTTER_PLUGIN_WB_TEXT_FIELD_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace wb_text_field {

class WbTextFieldPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WbTextFieldPlugin();

  virtual ~WbTextFieldPlugin();

  // Disallow copy and assign.
  WbTextFieldPlugin(const WbTextFieldPlugin&) = delete;
  WbTextFieldPlugin& operator=(const WbTextFieldPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace wb_text_field

#endif  // FLUTTER_PLUGIN_WB_TEXT_FIELD_PLUGIN_H_
