###
  Gyosen.utils.UAManager
  ユーザーエージェントよしなに
###

do(Gyosen)->
  UAManager = ()->
    throw new Error()

  UAManager.init =()->
    ua = navigator.userAgent
    appVer = navigator.appVersion
    UAManager.ua = ua
    UAManager.appVer = appVer

    if ua.indexOf('iPhone') > 0 and ua.indexOf('iPad') is -1
      UAManager.deviceType = "iPhone"
      UAManager.OS = "iOS"
    else if ua.indexOf('Android') > 0 and ua.indexOf('Mobile') > 0
      UAManager.deviceType = "AndroidSP"
      UAManager.OS = "Android"
    else if ua.indexOf('iPad') > 0 and ua.indexOf('iPhone') is -1
      UAManager.deviceType = "iPad"
      UAManager.OS = "iOS"
    else if ua.indexOf('Android') > 0
      UAManager.deviceType = "AndroidTab"
      UAManager.OS = "Android"
      version = ua.substr(ua.indexOf('Android')+8, 3)
      UAManager.osVersion = version
    else
      UAManager.deviceType = "PC"
      ua = ua.toLowerCase()
      appVer = navigator.appVersion.toLowerCase()
      UAManager.OS = UAManager.checkOS()
      if ua.indexOf('msie') != -1
        UAManager.current = UAManager.IE
        ver = appVer.match(/msie\s(\d.)?/)
        UAManager.version = Number(ver[1].split('.')[0])
        UAManager.OS = "Win"
      else if ua.indexOf('chrome') != -1
        matched = ua.match(/Chrome\/\d+/g)
        if matched
          chromeVer = Number(matched[0].split('/')[1])
          UAManager.version = chromeVer
        UAManager.current = UAManager.Chrome
      else if ua.indexOf('safari') != -1
        UAManager.current = UAManager.Safari
        matched = appVer.match(/version\/(\d.)/)
        UAManager.version = Number(matched[1].split('.')[0])
      else if ua.indexOf('gecko') != -1
        UAManager.current = UAManager.Firefox
        matched = ua.match(/firefox\/(\d.)/)
        UAManager.version = Number(matched[1].split('.')[0])
    UAManager.isInited = true


  UAManager.isOldIE =()->
    if UAManager.current isnt UAManager.IE
      return false
    if UAManager.version < 9
      return true
    return false

  UAManager.isOldChrome =()->
    if UAManager.current isnt UAManager.Chrome
      return false
    if UAManager.version < 25
      return true
    return false

  UAManager.checkOS =()->
    plat = navigator.platform
    if plat.indexOf('Win') != -1
      UAManager.OS = "Win"
    else
      UAManager.PS = "Mac"


  UAManager.ua = null
  UAManager.appVer = null
  UAManager.OS = null
  UAManager.isInited = false

  UAManager.current = ""
  UAManager.version = 0
  UAManager.deviceType = ""
  UAManager.deviceVersion = 0
  #types
  UAManager.Safari = "safari"
  UAManager.Firefox = "firefox"
  UAManager.Chrome = "chrome"
  UAManager.IE = "ie"
  UAManager.SP = "sp"
  UAManager.PAD = "pad"


  Gyosen.UAManager = UAManager
