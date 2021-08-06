package com.gstory.flutter_tencentad

import android.text.TextUtils
import android.util.Log


/**
 * @Description: 打印工具类
 * @Author: gstory
 * @CreateDate: 2021/8/6 17:51
 **/

/**
 *
 * 可自动把调用位置所在的类名和方法名作为tag，并可设置打印级别
 * dway
 */
object LogUtil {
    //以下为打印级别，级别从低到高
    const val LOG_LEVEL_VERBOSE = 1
    const val LOG_LEVEL_DEBUG = 2
    const val LOG_LEVEL_INFO = 3
    const val LOG_LEVEL_WARN = 4
    const val LOG_LEVEL_ERROR = 5
    const val LOG_LEVEL_NOLOG = 6
    private var AppName = ""
    private var PrintLine = false
    private var LogLevel = LOG_LEVEL_VERBOSE
    private var isShow = false

    /**
     * 可在打印的TAG前添加应用名标识，不设置则不输出
     */
    fun setAppName(appName: String) {
        AppName = appName
    }

    /**
     * 是否输出打印所在的行数，默认不输出
     */
    fun setPrintLine(enable: Boolean) {
        PrintLine = enable
    }

    /**
     * 可在打印的TAG前添加应用名标识，不设置则不输出
     */
    fun setShow(show: Boolean) {
        isShow = show
    }


    /**
     * 设置打印级别，且只有等于或高于该级别的打印才会输出
     */
    fun setLogLevel(logLevel: Int) {
        LogLevel = logLevel
    }

    fun v() {
        log(LOG_LEVEL_VERBOSE, "")
    }

    fun d() {
        log(LOG_LEVEL_DEBUG, "")
    }

    fun i() {
        log(LOG_LEVEL_INFO, "")
    }

    fun w() {
        log(LOG_LEVEL_WARN, "")
    }

    fun e() {
        log(LOG_LEVEL_ERROR, "")
    }

    fun v(msg: String) {
        if (LogLevel <= LOG_LEVEL_VERBOSE) {
            log(LOG_LEVEL_VERBOSE, msg)
        }
    }

    fun d(msg: String) {
        if (LogLevel <= LOG_LEVEL_DEBUG) {
            log(LOG_LEVEL_DEBUG, msg)
        }
    }

    fun i(msg: String) {
        if (LogLevel <= LOG_LEVEL_INFO) {
            log(LOG_LEVEL_INFO, msg)
        }
    }

    fun w(msg: String) {
        if (LogLevel <= LOG_LEVEL_WARN) {
            log(LOG_LEVEL_WARN, msg)
        }
    }

    fun e(msg: String) {
        if (LogLevel <= LOG_LEVEL_ERROR) {
            log(LOG_LEVEL_ERROR, msg)
        }
    }

    private fun log(logLevel: Int, msg: String) {
        if(!isShow){
            return
        }
        val caller = Thread.currentThread().stackTrace[4]
        var callerClazzName = caller.className
        if (callerClazzName.contains(".")) {
            callerClazzName = callerClazzName.substring(callerClazzName.lastIndexOf(".") + 1)
        }
        if (callerClazzName.contains("$")) {
            callerClazzName = callerClazzName.substring(0, callerClazzName.indexOf("$"))
        }
        var tag = callerClazzName
        if (!TextUtils.isEmpty(AppName)) {
            tag = AppName + "_" + tag
        }
        if (PrintLine) {
            tag += "(Line:%d)"
            tag = String.format(tag, caller.lineNumber)
        }
        tag = String.format(tag, callerClazzName)
        val message = "---" + caller.methodName + "---" + msg
        when (logLevel) {
            LOG_LEVEL_VERBOSE -> Log.v(tag, message)
            LOG_LEVEL_DEBUG -> Log.d(tag, message)
            LOG_LEVEL_INFO -> Log.i(tag, message)
            LOG_LEVEL_WARN -> Log.w(tag, message)
            LOG_LEVEL_ERROR -> Log.e(tag, message)
            LOG_LEVEL_NOLOG -> {
            }
        }
    }
}

