//
//  AKLibrary.swift
//
//  Created by Akihiro Matsuyama on 2021/08/27.
//
//  Akidon0000Library

import Foundation

enum AKLogLevel {
    case DEBUG     // システムの動作状況に関する詳細な情報。
    case WARN      // 異常とは言い切れないが正常とも異なる何らかの問題。
    case ERROR     // 予期しないその他の実行時エラー。
    case FATAL     // プログラムの異常終了を伴うようなもの。
}

/// ログ出力
///
/// - Parameters:
///   - file: ソースファイル名
///   - line: 行番号
///   - function: メソッド
///   - level: ログ・レベル
///   - message: メッセージ
func AKLog(file: String = #file,
           line: Int = #line,
           function: String = #function,
           level: AKLogLevel,
           message: Any ){
    
    #if DEBUG
    let levelString: String
    switch level {
    case .DEBUG:    levelString = "DEBUG"
    case .WARN:     levelString = "WARN"
    case .ERROR:    levelString = "ERROR"
    case .FATAL:    levelString = "FATAL"
    }

    let fileName = NSString(string: file).lastPathComponent
    let datetime = DateFormatter()
    datetime.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let now = datetime.string(from: Date())

    // コンソール出力
    print("AKLog: " + now + " \(levelString) \(fileName)(\(line)) \(function) \(message)")
    #endif
}
