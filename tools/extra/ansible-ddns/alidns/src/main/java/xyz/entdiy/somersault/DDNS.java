package xyz.entdiy.somersault;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.alidns.model.v20150109.DescribeDomainRecordsRequest;
import com.aliyuncs.alidns.model.v20150109.DescribeDomainRecordsResponse;
import com.aliyuncs.alidns.model.v20150109.UpdateDomainRecordRequest;
import com.aliyuncs.alidns.model.v20150109.UpdateDomainRecordResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.profile.DefaultProfile;
import com.google.gson.Gson;
import org.apache.commons.lang3.StringUtils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.SocketException;
import java.net.URL;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 动态域名解析: https://help.aliyun.com/document_detail/431629.html
 */
public class DDNS {

    /**
     * 获取主域名的所有解析记录列表
     */
    private DescribeDomainRecordsResponse describeDomainRecords(DescribeDomainRecordsRequest request, IAcsClient client) {
        try {
            // 调用SDK发送请求
            return client.getAcsResponse(request);
        } catch (ClientException e) {
            e.printStackTrace();
            // 发生调用错误，抛出运行时异常
            throw new RuntimeException();
        }
    }

    /**
     * 获取当前主机公网IP
     */
    private String getCurrentHostIP() {
//        // 这里使用jsonip.com第三方接口获取本地IP
//        String jsonip = "https://ipv6.jp2.test-ipv6.com/ip/?callback=_jqjsp&testdomain=test-ipv6.com&testname=test_aaaa";
//        // 接口返回结果
//        String result = "";
//        BufferedReader in = null;
//        try {
//            // 使用HttpURLConnection网络请求第三方接口
//            URL url = new URL(jsonip);
//            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
//            urlConnection.setRequestMethod("GET");
//            urlConnection.connect();
//            in = new BufferedReader(new InputStreamReader(
//                    urlConnection.getInputStream()));
//            String line;
//            while ((line = in.readLine()) != null) {
//                result += line;
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        // 使用finally块来关闭输入流
//        finally {
//            try {
//                if (in != null) {
//                    in.close();
//                }
//            } catch (Exception e2) {
//                e2.printStackTrace();
//            }
//        }
//
//        String res = StringUtils.substringBetween(result, "\"ip\":\"", "\",\"type\"");
//        return res;

        // 外部shell脚本获取到IPV6地址，以系统属性注入供alidns做判断动态处理
        return System.getProperty("ddns_cur_ip");
    }

    /**
     * 修改解析记录
     */
    private UpdateDomainRecordResponse updateDomainRecord(UpdateDomainRecordRequest request, IAcsClient client) {
        try {
            // 调用SDK发送请求
            return client.getAcsResponse(request);
        } catch (ClientException e) {
            e.printStackTrace();
            // 发生调用错误，抛出运行时异常
            throw new RuntimeException();
        }
    }

    private static void log_print(String functionName, Object result) {
        Gson gson = new Gson();
        System.out.println(LocalDateTime.now() + "-------------------------------" + functionName + "-------------------------------");
        System.out.println(gson.toJson(result));
    }

    public static void main(String[] args) throws SocketException {
        String[] domains = StringUtils.split(System.getProperty("ddns_domains"), ",");
        String domainName = System.getProperty("ddns_domain_name");
        System.out.println("Process "+System.getProperty("ddns_domains")+"."+domainName);

        // 设置鉴权参数，初始化客户端
        DefaultProfile profile = DefaultProfile.getProfile(
                System.getProperty("ddns_client_regionId"),// 地域ID
                System.getProperty("ddns_client_accessKeyId"),// 您的AccessKey ID
                System.getProperty("ddns_client_secret"));// 您的AccessKey Secret
        IAcsClient client = new DefaultAcsClient(profile);

        DDNS ddns = new DDNS();

        for (String domain : domains) {
            // 查询指定二级域名的最新解析记录
            DescribeDomainRecordsRequest describeDomainRecordsRequest = new DescribeDomainRecordsRequest();
            // 主域名
            describeDomainRecordsRequest.setDomainName(domainName);
            // 主机记录
            describeDomainRecordsRequest.setRRKeyWord(domain);
            // 解析记录类型
            describeDomainRecordsRequest.setType("AAAA");
            DescribeDomainRecordsResponse describeDomainRecordsResponse = ddns.describeDomainRecords(describeDomainRecordsRequest, client);
            log_print("describeDomainRecords", describeDomainRecordsResponse);

            List<DescribeDomainRecordsResponse.Record> domainRecords = describeDomainRecordsResponse.getDomainRecords();
            // 最新的一条解析记录
            if (domainRecords.size() != 0) {
                DescribeDomainRecordsResponse.Record record = domainRecords.get(0);
                // 记录ID
                String recordId = record.getRecordId();
                // 记录值
                String recordsValue = record.getValue();
                // 当前主机公网IP
                String currentHostIP = ddns.getCurrentHostIP();
                System.out.println("-------------------------------当前主机公网IP为：" + currentHostIP + "-------------------------------");
                if (!currentHostIP.equals(recordsValue)) {
                    // 修改解析记录
                    UpdateDomainRecordRequest updateDomainRecordRequest = new UpdateDomainRecordRequest();
                    // 主机记录
                    updateDomainRecordRequest.setRR(domain);
                    // 记录ID
                    updateDomainRecordRequest.setRecordId(recordId);
                    // 将主机记录值改为当前主机IP
                    updateDomainRecordRequest.setValue(currentHostIP);
                    // 解析记录类型
                    updateDomainRecordRequest.setType("AAAA");
                    UpdateDomainRecordResponse updateDomainRecordResponse = ddns.updateDomainRecord(updateDomainRecordRequest, client);
                    log_print("updateDomainRecord", updateDomainRecordResponse);
                }
            }
        }
    }
}
