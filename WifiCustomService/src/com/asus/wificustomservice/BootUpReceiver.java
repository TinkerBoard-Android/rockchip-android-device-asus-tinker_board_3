package com.asus.wificustomservice;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.os.SystemProperties;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class BootUpReceiver extends BroadcastReceiver {
    private final String TAG = "VoltageDetectService";
    private String mSocName = "";
    private String boardName = "";

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
            try {
                InputStream boardinfoIstream = Runtime.getRuntime().exec("cat /proc/boardinfo").getInputStream();
                InputStreamReader boardinfoIstreamReader = new InputStreamReader(boardinfoIstream);
                BufferedReader boardinfoBufReader = new BufferedReader(boardinfoIstreamReader);
                boardName = boardinfoBufReader.readLine();
                Log.i(TAG, "boardName:1111111111111111111111111111111111111 " + boardName);

                mSocName = SystemProperties.get("ro.board.platform");
                Log.i(TAG, "mSocName : " + mSocName);
                /*if (mSocName.equals("rk3288") && !boardName.equals("Tinker Board")) {
                    Log.i(TAG, "Start VoltageDetectService");

                    Intent serviceIntent = new Intent(context, VoltageDetectService.class);
                    context.startService(serviceIntent);
                }*/

                //boardinfoBufReader.close();
            } catch (Exception e) {
                Log.e(TAG, "Error detail", e);
            }
        }
    }
}
