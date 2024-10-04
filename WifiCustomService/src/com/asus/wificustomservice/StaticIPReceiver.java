package com.asus.wificustomservice;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.net.IpConfiguration;
import android.net.LinkAddress;
import android.net.StaticIpConfiguration;
import android.net.wifi.WifiManager;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiInfo;
import android.net.EthernetManager;
import android.text.TextUtils;
import java.net.InetAddress;
import java.net.Inet4Address;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkRequest;
import android.net.StaticIpConfiguration;
import android.net.wifi.WifiNetworkSpecifier;
import java.util.ArrayList;
import android.net.InetAddresses;
import android.net.IpConfiguration.IpAssignment;
import java.util.List;
import android.net.wifi.WifiInfo;

public class StaticIPReceiver extends BroadcastReceiver {
    private final String TAG = "StaticIPReceiver";
    String channelId = "default_channel_id";
    String channelDescription = "Default Channel";
    private EthernetManager mEthManager;
    private StaticIpConfiguration mStaticIpConfiguration = null;
    private IpAssignment mIpAssignment = IpAssignment.STATIC;
    private static final String ACTION_SET_STATIC_IP = "com.sanden_rs.crysta3.ACTION_PROVIDE_IP_DETAILS";

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.i(TAG, "onReceive");
        if (!ACTION_SET_STATIC_IP.equals(intent.getAction())) {
            Log.e(TAG, "Received unexpected intent: " + intent.getAction());
            return;
        }
	
        String mipAddress = intent.getStringExtra("staticIp");
        String mgateway = intent.getStringExtra("defaultGateway");
        String mdns1 = intent.getStringExtra("dnsServer1");
        String mdns2 = intent.getStringExtra("dnsServer2");
	int mnetworkPrefixLength = intent.getIntExtra("prefixLength", -1);

	String networkSSID = intent.getStringExtra("ssid");
	//String networkPassword = intent.getStringExtra("networkPassword");

	Log.i(TAG, "networkSSID = "+networkSSID );
        //Log.i(TAG, "networkSSID = "+networkSSID );
        Log.i(TAG, "mipAddress = "+mipAddress +"mgateway = "+ mgateway);
	Log.i(TAG, "mdns1 = "+mdns1 +"mdns2 = "+ mdns2 + "mnetworkPrefixLength = "+mnetworkPrefixLength);

        if (mipAddress == null) {
                 Log.i(TAG, "Do nothing because mipAddress null");
                 return;
        }

	WifiManager wifiManager = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);


        WifiInfo wifiInfo = wifiManager.getConnectionInfo();
        WifiConfiguration wifiConfiguration = new WifiConfiguration();
        if (wifiInfo != null) {
            int networkId = wifiInfo.getNetworkId();
            for (WifiConfiguration config : wifiManager.getConfiguredNetworks()) {
	        String cleanSSID = config.SSID.replace("\"", "").trim();
	        Log.i(TAG, "Check the link SSID="+ cleanSSID);
                    if (config.SSID != null && cleanSSID.equals(networkSSID)) {
		        Log.i(TAG, "Match the SSID = "+ cleanSSID);
		        Log.i(TAG, "Check the networkID="+ config.networkId+"wifiInfo.getNetworkId"+networkId);
                        if (config.networkId == networkId) {
                            wifiConfiguration = config;
                            break;
	                }
                    }
            }
        }


        Log.i(TAG, "Check wifiConfiguration.SSID ="+ wifiConfiguration.SSID);
        if (wifiConfiguration.SSID != null) {
            Log.i(TAG, "Check wifiConfiguration.SSID not null ="+ wifiConfiguration.SSID);


	mStaticIpConfiguration = new StaticIpConfiguration();

        String ipAddr = mipAddress;
        Inet4Address inetAddr = getIPv4Address(ipAddr);
        if (inetAddr == null || inetAddr.equals(Inet4Address.ANY)) {
            Log.i(TAG, "Do nothing because the Inet4Address format fail or null");
            return;
        }
        StaticIpConfiguration.Builder staticIPBuilder = new StaticIpConfiguration.Builder();
        try {
            int networkPrefixLength = -1;
            try {
                networkPrefixLength = Integer.parseInt("24");
                if (networkPrefixLength < 0 || networkPrefixLength > 32) {
                    Log.i(TAG, "Do noting becuase networkPrefixLength < 0 || networkPrefixLength > 32");
		    return;
                } else {
                	staticIPBuilder.setIpAddress(new LinkAddress(inetAddr, networkPrefixLength));
		}
            } catch (NumberFormatException e) {
                Log.e(TAG, "NumberFormatException " + e);
		return;
            } catch (IllegalArgumentException e) {
                Log.e(TAG, "IllegalArgumentException " + e);
                return;
            }

	    if (mgateway == null) {
		Log.i(TAG, "Warning: mgateway null");
	    } else {
            	String gateway = mgateway;

                InetAddress gatewayAddr = getIPv4Address(mgateway);
                if (gatewayAddr == null) {
                    Log.i(TAG, "Warning: gateway InetAddress format null");
                } else {
                	if (gatewayAddr.isMulticastAddress()) {
                    		Log.i(TAG, "gatewayAddr.isMulticastAddress null");
                	} else {
                		staticIPBuilder.setGateway(gatewayAddr);
			}
		}
	    }


            String dns = null;
            InetAddress dnsAddr = null;
            final ArrayList<InetAddress> dnsServers = new ArrayList<>();
	        
            if (mdns1 == null) {
		Log.i(TAG, "dns1 dnsAddr IPv4Address null");
            } else {
		dns = mdns1;
		dnsAddr = getIPv4Address(dns);
		if (dnsAddr == null) {
			Log.i(TAG, "dns1 dnsAddr IPv4Address null");
		} else {
			dnsServers.add(dnsAddr);
		}
            }

	    if (mdns2 == null) {
		Log.i(TAG, "intent dns2 null");
            } else {
		dns = mdns2;
		dnsAddr = getIPv4Address(dns);
		if (dnsAddr == null) {
			Log.i(TAG, "dns2 dnsAddr IPv4Address null");
		} else {
			dnsServers.add(dnsAddr);
		}
	    }

	    if (dnsAddr == null) {
	    	Log.i(TAG, "dnsAddr InetAddress list null");
	    } else {
            	staticIPBuilder.setDnsServers(dnsServers);
	    }
            mStaticIpConfiguration = staticIPBuilder.build();

        } finally {
            // Caller of this method may rely on staticIpConfiguration, so build the final result
            // at the end of the method.
            mStaticIpConfiguration = staticIPBuilder.build();
        }

	Log.i(TAG, "Set the IpConfiguration");
        IpConfiguration ipConfig = new IpConfiguration();
        ipConfig.setIpAssignment(mIpAssignment);
        ipConfig.setStaticIpConfiguration(mStaticIpConfiguration);
        wifiConfiguration.setIpConfiguration(ipConfig);

	Log.i(TAG, "get the networkId");
	int networkId = -1;

	int currentNetworkId = wifiConfiguration.networkId;

	Log.i(TAG, "Confirme the currentNetworkId ="+ currentNetworkId);
	wifiManager.disableNetwork(currentNetworkId);

	networkId = wifiManager.addNetwork(wifiConfiguration);

	Log.i(TAG, "link the networkID="+ networkId);
        //wifiManager.disconnect();
        wifiManager.enableNetwork(networkId, true);
        wifiManager.reconnect();
    }

    }


    private Inet4Address getIPv4Address(String text) {
        try {
            return (Inet4Address) InetAddresses.parseNumericAddress(text);
        } catch (IllegalArgumentException | ClassCastException e) {
            return null;
        }
    }


}
