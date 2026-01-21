package com.qmc.simpleAlarm

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * 增强的权限处理器
 * 处理确保闹钟全自动半永久执行所需的所有权限
 */
class EnhancedPermissionHandler(private val context: Context) : MethodCallHandler {
    
    companion object {
        private const val CHANNEL = "enhanced_permission_service"
    }
    
    fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(this)
    }
    
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "canScheduleExactAlarms" -> canScheduleExactAlarms(result)
            "requestScheduleExactAlarmPermission" -> requestScheduleExactAlarmPermission(result)
            "isIgnoringBatteryOptimizations" -> isIgnoringBatteryOptimizations(result)
            "requestIgnoreBatteryOptimizations" -> requestIgnoreBatteryOptimizations(result)
            "requestBackgroundActivityPermission" -> requestBackgroundActivityPermission(result)
            
            // 厂商特定权限
            "requestMiuiAutoStart" -> requestMiuiAutoStart(result)
            "requestHuaweiAutoStart" -> requestHuaweiAutoStart(result)
            "requestOppoAutoStart" -> requestOppoAutoStart(result)
            "requestVivoAutoStart" -> requestVivoAutoStart(result)
            "requestSamsungAutoStart" -> requestSamsungAutoStart(result)
            "requestMeizuAutoStart" -> requestMeizuAutoStart(result)
            "requestGenericAutoStart" -> requestGenericAutoStart(result)
            
            // 厂商特定功能权限
            "requestMiuiBackgroundStart" -> requestMiuiBackgroundStart(result)
            "requestMiuiDisplayPopup" -> requestMiuiDisplayPopup(result)
            "requestHuaweiProtectedApps" -> requestHuaweiProtectedApps(result)
            "requestOppoBackgroundStart" -> requestOppoBackgroundStart(result)
            "requestVivoBackgroundStart" -> requestVivoBackgroundStart(result)
            "requestMeizuBackgroundStart" -> requestMeizuBackgroundStart(result)
            
            "showPermissionGuide" -> showPermissionGuide(result)
            
            else -> result.notImplemented()
        }
    }
    
    /**
     * 检查是否可以调度精确闹钟 (Android 12+)
     */
    private fun canScheduleExactAlarms(result: Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            result.success(alarmManager.canScheduleExactAlarms())
        } else {
            result.success(true)
        }
    }
    
    /**
     * 请求精确闹钟权限 (Android 12+)
     */
    @RequiresApi(Build.VERSION_CODES.S)
    private fun requestScheduleExactAlarmPermission(result: Result) {
        try {
            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                data = Uri.parse("package:${context.packageName}")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 检查是否忽略电池优化
     */
    private fun isIgnoringBatteryOptimizations(result: Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            result.success(powerManager.isIgnoringBatteryOptimizations(context.packageName))
        } else {
            result.success(true)
        }
    }
    
    /**
     * 请求忽略电池优化
     */
    private fun requestIgnoreBatteryOptimizations(result: Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = Uri.parse("package:${context.packageName}")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
            }
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 请求后台启动活动权限
     */
    private fun requestBackgroundActivityPermission(result: Result) {
        try {
            // 尝试打开应用详情页面
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.parse("package:${context.packageName}")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    // ========== 厂商特定自启动权限 ==========
    
    /**
     * 请求小米MIUI自启动权限
     */
    private fun requestMiuiAutoStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            // 尝试备用方案
            try {
                val intent = Intent("miui.intent.action.APP_PERM_EDITOR").apply {
                    setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity")
                    putExtra("extra_pkgname", context.packageName)
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
                result.success(true)
            } catch (e2: Exception) {
                result.success(false)
            }
        }
    }
    
    /**
     * 请求华为EMUI自启动权限
     */
    private fun requestHuaweiAutoStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            // 尝试备用方案
            try {
                val intent = Intent().apply {
                    setClassName("com.huawei.systemmanager", "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
                result.success(true)
            } catch (e2: Exception) {
                result.success(false)
            }
        }
    }
    
    /**
     * 请求OPPO ColorOS自启动权限
     */
    private fun requestOppoAutoStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            // 尝试备用方案
            try {
                val intent = Intent().apply {
                    setClassName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
                result.success(true)
            } catch (e2: Exception) {
                result.success(false)
            }
        }
    }
    
    /**
     * 请求VIVO FuntouchOS自启动权限
     */
    private fun requestVivoAutoStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            // 尝试备用方案
            try {
                val intent = Intent().apply {
                    setClassName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
                result.success(true)
            } catch (e2: Exception) {
                result.success(false)
            }
        }
    }
    
    /**
     * 请求三星One UI自启动权限
     */
    private fun requestSamsungAutoStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            // 尝试备用方案
            try {
                val intent = Intent().apply {
                    setClassName("com.samsung.android.sm_cn", "com.samsung.android.sm.ui.ram.AutoRunActivity")
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
                result.success(true)
            } catch (e2: Exception) {
                result.success(false)
            }
        }
    }
    
    /**
     * 请求魅族Flyme自启动权限
     */
    private fun requestMeizuAutoStart(result: Result) {
        try {
            val intent = Intent("com.meizu.safe.security.SHOW_APPSEC").apply {
                setClassName("com.meizu.safe", "com.meizu.safe.security.AppSecActivity")
                putExtra("packageName", context.packageName)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 通用自启动权限请求
     */
    private fun requestGenericAutoStart(result: Result) {
        try {
            // 打开应用详情页面
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.parse("package:${context.packageName}")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    // ========== 厂商特定功能权限 ==========
    
    /**
     * 请求小米后台启动权限
     */
    private fun requestMiuiBackgroundStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity")
                putExtra("extra_pkgname", context.packageName)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 请求小米显示悬浮窗权限
     */
    private fun requestMiuiDisplayPopup(result: Result) {
        try {
            val intent = Intent("miui.intent.action.APP_PERM_EDITOR").apply {
                setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity")
                putExtra("extra_pkgname", context.packageName)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 请求华为受保护应用权限
     */
    private fun requestHuaweiProtectedApps(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 请求OPPO后台启动权限
     */
    private fun requestOppoBackgroundStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 请求VIVO后台启动权限
     */
    private fun requestVivoBackgroundStart(result: Result) {
        try {
            val intent = Intent().apply {
                setClassName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 请求魅族后台启动权限
     */
    private fun requestMeizuBackgroundStart(result: Result) {
        try {
            val intent = Intent("com.meizu.safe.security.SHOW_APPSEC").apply {
                setClassName("com.meizu.safe", "com.meizu.safe.security.AppSecActivity")
                putExtra("packageName", context.packageName)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
    
    /**
     * 显示权限设置指导
     */
    private fun showPermissionGuide(result: Result) {
        try {
            // 打开应用设置页面
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.parse("package:${context.packageName}")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.success(false)
        }
    }
}
