package com.qmc.simpleAlarm

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.media.MediaPlayer
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.TextView
import java.text.SimpleDateFormat
import java.util.*

class AlarmScreenActivity : Activity() {
    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    
    companion object {
        const val EXTRA_ALARM_ID = "alarm_id"
        const val EXTRA_ALARM_TITLE = "alarm_title"
        const val EXTRA_ALARM_BODY = "alarm_body"
        
        fun createIntent(context: Context, alarmId: Int, title: String, body: String): Intent {
            return Intent(context, AlarmScreenActivity::class.java).apply {
                putExtra(EXTRA_ALARM_ID, alarmId)
                putExtra(EXTRA_ALARM_TITLE, title)
                putExtra(EXTRA_ALARM_BODY, body)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or 
                       Intent.FLAG_ACTIVITY_CLEAR_TOP or
                       Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 设置全屏显示
        setupFullScreen()
        
        // 设置布局
        setupLayout()
        
        // 开始振动和声音
        startAlarmEffects()
    }
    
    private fun setupFullScreen() {
        // 设置窗口标志以实现全屏显示
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
        
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
            WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )
        
        // 隐藏系统UI
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            window.decorView.systemUiVisibility = (
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
                View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
                View.SYSTEM_UI_FLAG_FULLSCREEN or
                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
            )
        }
    }
    
    private fun setupLayout() {
        // 创建简单的布局
        val layout = """
            <?xml version="1.0" encoding="utf-8"?>
            <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:orientation="vertical"
                android:gravity="center"
                android:background="#FF1976D2"
                android:padding="32dp">
                
                <TextView
                    android:id="@+id/time_text"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:textSize="48sp"
                    android:textColor="#FFFFFF"
                    android:textStyle="bold"
                    android:layout_marginBottom="16dp" />
                    
                <TextView
                    android:id="@+id/title_text"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:textSize="24sp"
                    android:textColor="#FFFFFF"
                    android:textStyle="bold"
                    android:layout_marginBottom="8dp" />
                    
                <TextView
                    android:id="@+id/body_text"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:textSize="16sp"
                    android:textColor="#FFFFFF"
                    android:layout_marginBottom="32dp"
                    android:gravity="center" />
                    
                <LinearLayout
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:orientation="horizontal">
                    
                    <Button
                        android:id="@+id/stop_button"
                        android:layout_width="120dp"
                        android:layout_height="60dp"
                        android:text="停止"
                        android:textSize="18sp"
                        android:layout_marginEnd="16dp"
                        android:backgroundTint="#FF4CAF50" />
                        
                    <Button
                        android:id="@+id/snooze_button"
                        android:layout_width="120dp"
                        android:layout_height="60dp"
                        android:text="稍后提醒"
                        android:textSize="18sp"
                        android:backgroundTint="#FFFF9800" />
                        
                </LinearLayout>
                
            </LinearLayout>
        """.trimIndent()
        
        // 由于我们不能直接使用XML字符串，我们需要程序化创建布局
        createProgrammaticLayout()
    }
    
    private fun createProgrammaticLayout() {
        val layout = android.widget.LinearLayout(this).apply {
            orientation = android.widget.LinearLayout.VERTICAL
            gravity = android.view.Gravity.CENTER
            setBackgroundColor(0xFF1976D2.toInt())
            setPadding(96, 96, 96, 96)
        }
        
        // 时间显示
        val timeText = TextView(this).apply {
            id = View.generateViewId()
            textSize = 48f
            setTextColor(0xFFFFFFFF.toInt())
            typeface = android.graphics.Typeface.DEFAULT_BOLD
            text = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date())
        }
        
        // 标题
        val titleText = TextView(this).apply {
            id = View.generateViewId()
            textSize = 24f
            setTextColor(0xFFFFFFFF.toInt())
            typeface = android.graphics.Typeface.DEFAULT_BOLD
            text = intent.getStringExtra(EXTRA_ALARM_TITLE) ?: "闹钟"
        }
        
        // 内容
        val bodyText = TextView(this).apply {
            id = View.generateViewId()
            textSize = 16f
            setTextColor(0xFFFFFFFF.toInt())
            gravity = android.view.Gravity.CENTER
            text = intent.getStringExtra(EXTRA_ALARM_BODY) ?: "时间到了！"
        }
        
        // 按钮布局
        val buttonLayout = android.widget.LinearLayout(this).apply {
            orientation = android.widget.LinearLayout.HORIZONTAL
        }
        
        // 停止按钮
        val stopButton = Button(this).apply {
            text = "停止"
            textSize = 18f
            setBackgroundColor(0xFF4CAF50.toInt())
            setOnClickListener { stopAlarm() }
        }
        
        // 稍后提醒按钮
        val snoozeButton = Button(this).apply {
            text = "稍后提醒"
            textSize = 18f
            setBackgroundColor(0xFFFF9800.toInt())
            setOnClickListener { snoozeAlarm() }
        }
        
        // 添加视图
        layout.addView(timeText)
        layout.addView(titleText)
        layout.addView(bodyText)
        
        buttonLayout.addView(stopButton)
        buttonLayout.addView(snoozeButton)
        layout.addView(buttonLayout)
        
        setContentView(layout)
    }
    
    private fun startAlarmEffects() {
        // 开始自定义振动模式
        vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // 自定义震动模式：短震-长震-短震-长震，循环
            val vibrationPattern = longArrayOf(0, 500, 300, 1000, 300, 500, 300, 1000)
            vibrator?.vibrate(VibrationEffect.createWaveform(vibrationPattern, 0))
        } else {
            // 兼容旧版本的震动模式
            val vibrationPattern = longArrayOf(0, 500, 300, 1000, 300, 500, 300, 1000)
            vibrator?.vibrate(vibrationPattern, 0)
        }
        
        // 播放自定义闹钟声音
        try {
            mediaPlayer = MediaPlayer().apply {
                setAudioStreamType(AudioManager.STREAM_ALARM)
                // 尝试播放自定义闹钟音频文件
                val assetFileDescriptor = assets.openFd("flutter_assets/assets/alarm.mp3")
                setDataSource(assetFileDescriptor.fileDescriptor, assetFileDescriptor.startOffset, assetFileDescriptor.length)
                assetFileDescriptor.close()
                isLooping = true
                // 不设置音量，使用系统默认音量
                prepare()
                start()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            // 如果自定义音频加载失败，回退到系统默认闹钟声音
            try {
                mediaPlayer = MediaPlayer().apply {
                    setAudioStreamType(AudioManager.STREAM_ALARM)
                    setDataSource(this@AlarmScreenActivity, android.provider.Settings.System.DEFAULT_ALARM_ALERT_URI)
                    isLooping = true
                    setVolume(1.0f, 1.0f) // 使用系统当前音量设置
                    prepare()
                    start()
                }
            } catch (fallbackException: Exception) {
                fallbackException.printStackTrace()
            }
        }
    }
    
    private fun stopAlarm() {
        stopAlarmEffects()
        finish()
    }
    
    private fun snoozeAlarm() {
        stopAlarmEffects()
        // TODO: 实现稍后提醒逻辑
        finish()
    }
    
    private fun stopAlarmEffects() {
        mediaPlayer?.stop()
        mediaPlayer?.release()
        mediaPlayer = null
        
        vibrator?.cancel()
        vibrator = null
    }
    
    override fun onDestroy() {
        super.onDestroy()
        stopAlarmEffects()
    }
    
    override fun onBackPressed() {
        // 防止用户通过返回键关闭闹钟
        // 可以选择忽略或者显示确认对话框
    }
}