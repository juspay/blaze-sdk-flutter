import BlazeSDK
import Flutter
import Foundation
import UIKit

public class BlazeSdkFlutterPlugin: NSObject, FlutterPlugin {

    private var blaze: Blaze?
    private var methodChannel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "blaze_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = BlazeSdkFlutterPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(
        _ call: FlutterMethodCall, result: @escaping FlutterResult
    ) {
        switch call.method {
        case "initiate":
            initiate(initiatePayload: call.arguments)
            result(true)
        case "process":
            process(processPayload: call.arguments)
            result(true)
        case "handleBackPress":
            result(handleBackPress())
        case "terminate":
            terminate()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initiate(initiatePayload: Any?) {
        blaze = Blaze()
        let initiatePayloadJson = safeParseJson(initiatePayload)
        DispatchQueue.main.async {
            if let blaze = self.blaze,
                let rootViewController = UIApplication.shared.delegate?.window??
                    .rootViewController
            {
                blaze.initiate(
                    context: rootViewController,
                    initiatePayload: initiatePayloadJson
                ) { result in
                    if let resultData = try? JSONSerialization.data(
                        withJSONObject: result, options: []),
                        let resultString = String(
                            data: resultData, encoding: .utf8)
                    {
                        self.methodChannel?.invokeMethod(
                            "blaze-callback", arguments: resultString)
                    }
                }
            }
        }
    }

    private func process(processPayload: Any?) {
        let processPayloadJson = safeParseJson(processPayload)
        blaze?.process(payload: processPayloadJson)
    }

    private func handleBackPress() -> Bool {
        return true
    }

    private func terminate() {
        blaze?.terminate()
    }

    // Utility method to parse JSON
    func safeParseJson(_ json: Any?) -> [String: Any] {
        guard let jsonString = json as? String else {
            return [:]
        }
        if let data = jsonString.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(
                    with: data, options: [])
                    as? [String: Any]
                {
                    return json
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        return [:]
    }

}
