FORMAT: 1A

# IOTインターン2020

## アラート送信 [POST /api/v1/alert]

お掃除ロボットに異常が発生したことをLinkitに通知します.

+ Request (application/json)
    + Attributes
        + `type`: `derailment` (enum[string], required) - 異常の種類
            + `dead_battery`: パッテリー切れ
            + `derailment`: 脱輪
            + `jamming`: 異物混入

+ Response 201 (application/json)

+ Response 400 (application/json)
    + RequestBodyが不正な場合に発生する
    + Attributes (BadRequest)

+ Response 500 (application/json)
    + Linkitへのメッセージの送信に失敗した場合に発生する
    + Attributes (LinkitError)

# Data Structures

## BadRequest (object)

+ `type`: `BadRequest` (string, fixed) - エラー種別
+ `message`: `Unable to understand the request` (string, fixed) - エラーの詳細

## LinkitError (object)

+ `type`: `LinkitError` (string, fixed) - エラー種別
+ `message`: `Error caused on Linkit` (string, fixed) - エラーの詳細
