do(window)->
  Gyosen = {
    "version": 0.1
    "debug": true
    "name": "Gyosen"
    "defaultLogLevel": "info"
    "logLevel":["info", "error", "warning"]
    "INFO":"info"
    "ERROR": "error"
    "WARNING": "warning"
    "setting":
      "SUCCESS_STATUS_CODE":[200, 304]
      "ERROR_STATUS_CODE": [403, 404, 500, 503, 505]
  }

  #いるかなー
  Gyosen.setup =()=>
    return
  # class Gyosen extends Kazitori
  #   routes:
  #     '/': 'index'
  window.Gyosen = Gyosen