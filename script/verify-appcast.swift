#!/usr/bin/env swift
// 上传前核对发布包与更新清单，并直接使用应用内的公钥验证 Ed25519 签名。
import CryptoKit
import Foundation

enum VerificationError: Error, CustomStringConvertible {
    case invalid(String)

    var description: String {
        switch self {
        case let .invalid(message): message
        }
    }
}

func require(_ condition: Bool, _ message: String) throws {
    if !condition {
        throw VerificationError.invalid(message)
    }
}

func readPlist(_ path: String) throws -> [String: Any] {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
        throw VerificationError.invalid("Invalid plist: \(path)")
    }
    return plist
}

do {
    let arguments = Array(CommandLine.arguments.dropFirst())
    try require(arguments.count == 7, "Usage: verify-appcast.swift appcast zip archive-plist config-plist release-json tag bootstrap")
    let archive = try Data(contentsOf: URL(fileURLWithPath: arguments[1]))
    let info = try readPlist(arguments[2])
    let configuration = try readPlist(arguments[3])
    let metadataData = try Data(contentsOf: URL(fileURLWithPath: arguments[4]))
    guard let metadata = try JSONSerialization.jsonObject(with: metadataData) as? [String: Any],
          let assets = metadata["assets"] as? [[String: Any]],
          let asset = assets.first(where: { $0["name"] as? String == "Floe.zip" }),
          let build = info["CFBundleVersion"] as? String,
          let version = info["CFBundleShortVersionString"] as? String,
          let publicKeyString = configuration["SUPublicEDKey"] as? String,
          let publicKeyData = Data(base64Encoded: publicKeyString)
    else {
        throw VerificationError.invalid("Missing release, version or public key metadata")
    }
    let tag = arguments[5]
    let bootstrap = arguments[6] == "true"
    let feedURL = "https://github.com/wudb/Floe/releases/latest/download/appcast.xml"
    let downloadURL = "https://github.com/wudb/Floe/releases/download/\(tag)/Floe.zip"
    try require(metadata["tagName"] as? String == tag, "Release tag mismatch")
    try require(metadata["isPrerelease"] as? Bool == false, "Stable feed cannot contain a prerelease")
    try require("v\(version)" == tag, "Archive version does not match release tag")
    try require(info["CFBundleIdentifier"] as? String == "com.float.floe", "Archive bundle identifier mismatch")
    try require(configuration["SUFeedURL"] as? String == feedURL, "Unexpected configured update feed")
    try require(asset["url"] as? String == downloadURL, "Unexpected release download URL")
    try require(asset["state"] as? String == "uploaded", "Release archive upload is incomplete")
    try require(asset["size"] as? Int == archive.count, "Release archive size mismatch")
    let digest = SHA256.hash(data: archive).map { String(format: "%02x", $0) }.joined()
    try require(asset["digest"] as? String == "sha256:\(digest)", "Release archive SHA-256 mismatch")
    if bootstrap {
        try require(info["SUPublicEDKey"] == nil, "Bootstrap is only for legacy archives without an update key")
        print("Legacy archive bootstrap: users must manually install a build with the configured update key.")
    } else {
        try require(info["SUPublicEDKey"] as? String == publicKeyString, "Archive public key mismatch")
        try require(info["SUFeedURL"] as? String == feedURL, "Archive update feed mismatch")
    }

    let document = try XMLDocument(contentsOf: URL(fileURLWithPath: arguments[0]))
    let items = try document.nodes(forXPath: "/rss/channel/item")
    try require(items.count == 1, "Expected one full update in the appcast")
    guard let item = items.first as? XMLElement,
          let enclosure = item.elements(forName: "enclosure").first,
          let signatureString = enclosure.attribute(forName: "sparkle:edSignature")?.stringValue,
          let signature = Data(base64Encoded: signatureString)
    else {
        throw VerificationError.invalid("Missing Ed25519 update signature")
    }
    try require(item.elements(forName: "sparkle:version").first?.stringValue == build, "Appcast build mismatch")
    try require(item.elements(forName: "sparkle:shortVersionString").first?.stringValue == version, "Appcast version mismatch")
    try require(
        item.elements(forName: "sparkle:minimumSystemVersion").first?.stringValue == info["LSMinimumSystemVersion"] as? String,
        "Appcast minimum macOS version mismatch"
    )
    try require(enclosure.attribute(forName: "url")?.stringValue == downloadURL, "Appcast download URL mismatch")
    try require(enclosure.attribute(forName: "length")?.stringValue == String(archive.count), "Appcast length mismatch")
    let key = try Curve25519.Signing.PublicKey(rawRepresentation: publicKeyData)
    try require(key.isValidSignature(signature, for: archive), "Archive signature does not match Floe's configured public key")
    print("Verified Floe \(version) (\(build)), SHA-256 and Ed25519 signature")
} catch {
    fputs("Appcast verification failed: \(error)\n", stderr)
    exit(1)
}
