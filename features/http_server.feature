# language: ja

機能: httpサーバ
  webサーバを提供するために
  HTTPクライアントの立場から
  HTTPのレスポンスをチェックする


  シナリオ: HTTPクライアントリクエスト
    前提: HTTPで localhost にリクエストする
    ならば: レスポンスのステータスが 200 だ

  シナリオ: 名前ベースでHTTPクライアントリクエスト
    前提: Hostヘッダ に "www.example.com" をつけてHTTPで localhost にリクエストする
    ならば: レスポンスのステータスが 200 だ
    かつ: コンテンツに www.example.com が含まれている
