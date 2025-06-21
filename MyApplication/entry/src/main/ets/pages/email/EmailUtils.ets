/*
 * Created by Gqz (gaoqizhi@hiby.com) on 2025/6/19
 */
import {
   MimeTypeDetector,
   EmlFormat,
   Store,
   Properties,
   TransPort,
   MailLogger,
   MimeMessage,
   RecipientType,
   AttachmentBody
} from '@ohos/mail';
import hilog from '@ohos.hilog'
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError, zlib, deviceInfo as devInfo } from '@kit.BasicServicesKit';
import { bundleManager as bundleMgr, Context } from '@kit.AbilityKit';
import statvfs from '@ohos.file.statvfs';

export class EmailHelper {
   private readonly TAG = 'EmailUtils: ***'
   //
   private from: string = "hibylogsends@163.com";
   private pwd: string = "GWgQ5dxBBa7uhM32";
   private to: string[] = ['hibyReceiveLog@163.com'];
   private cc: string[] = ['gowcage@163.com'];
   private host: string = "smtp.163.com";
   private port: number = 25;
   //
   private transport: TransPort | undefined

   createClient(): Promise<boolean> {
      /*
  "mailServerHost" : "smtp.163.com",
  "password" : "16C297662D60ADED0971006BB0D149ECC1912C4A4A5F6FD93CDB4FB48EF2D0B9",  // GWgQ5dxBBa7uhM32
  "recevieUserName" : "hibyReceiveLog@163.com",
  "sendUserName" : "hibylogsends@163.com"
       * */
      return new Promise((resolve, reject) => {
         let properties = new Properties()
         properties.setFrom(this.from)
         properties.setHost(this.host)
         properties.setPort(this.port)
         //设置是否使用ssl
         properties.ssl(false)
         properties.setAuthorizationCode(this.pwd) //gaoqizhi43250

         let transport = new TransPort()
         //连接服务
         transport.connect(properties, (success: boolean, err: Error) => {
            if (success) {
               this.transport = transport
               hilog.info(0, this.TAG, 'ohos_mail-- login smtp success:')
               resolve(true)
            } else {
               this.transport = undefined
               hilog.error(0, this.TAG, JSON.stringify(err))
               hilog.error(0, this.TAG, 'ohos_mail-- login smtp fail:' + err)
               resolve(false)
            }
         });
      })
   }

   send(subject: string, msg: string, filePath: string): Promise<boolean> {
      let transport = this.transport
      return new Promise((resolve, reject) => {
         if (!transport) {
            reject("transport is undefined")
         } else {
            let mimeMessage = new MimeMessage()
            mimeMessage.setFrom(this.from)
            mimeMessage.setRecipients(RecipientType.TO, this.cc)
            mimeMessage.setRecipients(RecipientType.CC, this.cc)
            mimeMessage.setMIMEVersion("1.0")
            mimeMessage.setSubject(subject)
            mimeMessage.setText(msg)
            //设置附件
            let dirPath = filePath.substring(0, filePath.lastIndexOf("/"))
            let fileName = filePath.substring(filePath.lastIndexOf("/") + 1)
            let attachment1 = new AttachmentBody(dirPath, fileName)
            //如果是在taskpool中使用需要调用下面方法将GlobalContext.getContext().getValue('cacheContent')传递进去，反之可以不用调
            //attachment1.setCacheContent(GlobalContext.getContext().getValue('cacheContent'))
            mimeMessage.addAttachmentBody(attachment1)

            //发送邮件
            transport.sendMessage(mimeMessage, (err: Error) => {
               if (!err) {
                  hilog.info(0, this.TAG, '发送成功！')
                  resolve(true)
               } else {
                  hilog.error(0, this.TAG, "发送失败：" + JSON.stringify(err))
                  resolve(false)
               }
            })
         }
      })
   }

   close() {
      //关闭连接
      this.transport?.close((err: Error) => {
         if (!err) {
            hilog.info(0, this.TAG, 'ohos_mail-- socket close success!');
         } else {
            hilog.info(0, this.TAG, 'ohos_mail-- socket close fail:' + err);
         }
      })
   }

   /*
    * 压缩文件
    * @param zipFile 压缩文件路径, full sandbox path
    * @param files 需要压缩的文件列表, full sandbox path
    * */
   zipFiles(zipFile: string, files: string[]): Promise<boolean> {
      return new Promise((resolve, reject) => {
         try {
            let options: zlib.Options = {
               level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
               memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
               strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY,
               // parallel: zlib.ParallelStrategy.PARALLEL_STRATEGY_SEQUENTIAL
            };
            zlib.compressFiles(files, zipFile, options).then((data: void) => {
               hilog.info(0, this.TAG, 'compressFile success, data: ' + JSON.stringify(data))
               resolve(true)
            }).catch((errData: BusinessError) => {
               hilog.error(0, this.TAG,
                  `compressFile errCode: ${errData.code}, message: ${errData.message}`)
               resolve(false)
            })
         } catch (e) {
            hilog.error(0, this.TAG, 'compressFile err: ' + JSON.stringify(e))
            resolve(false)
         }
      })
   }

   getZipFilePath(ctx: Context, name: string): string {
      let path = ctx.filesDir + '/' + name
      if (fs.accessSync(path, fs.AccessModeType.EXIST)) {
         fs.unlinkSync(path)
      }
      fs.openSync(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
      return path
   }

   getReportInfo(ctx:Context): string {

      let appVer = ''
      let packageName = ''
      let phoneModel = ''
      let osVer = ''
      let board = ''
      let brand = ''
      let devName = ''
      let model = ''
      let product = ''
      let time = 0
      let type = ''
      let user = ''
      let totalInnerMem = 0
      let availableInnerMem = 0

      let deviceTypeInfo: string = devInfo.deviceType;
      // 输出结果：the value of the deviceType is :wearable
      hilog.info(0, this.TAG, 'the value of the deviceType is :' + deviceTypeInfo);

      let brandInfo: string = devInfo.brand;
      // 输出结果：the value of the brand is :HUAWEI
      hilog.info(0, this.TAG, 'the value of the device brand is :' + brandInfo);

      let marketNameInfo: string = devInfo.marketName;
      // 输出结果：the value of the marketName is :Mate XX
      hilog.info(0, this.TAG, 'the value of the deviceInfo marketName is :' + marketNameInfo);

      let productSeriesInfo: string = devInfo.productSeries;
      // 输出结果：the value of the productSeries is :TAS
      hilog.info(0, this.TAG, 'the value of the deviceInfo productSeries is :' + productSeriesInfo);

      let productModelInfo: string = devInfo.productModel;
      // 输出结果：the value of the productModel is :TAS-AL00
      hilog.info(0, this.TAG, 'the value of the deviceInfo productModel is :' + productModelInfo);

      let productModelAliasInfo: string = devInfo.productModelAlias;
      hilog.info(0, this.TAG, 'the value of the deviceInfo productModelAlias is :' + productModelAliasInfo);

      let softwareModelInfo: string = devInfo.softwareModel;
      // 输出结果：the value of the softwareModel is :TAS-AL00
      hilog.info(0, this.TAG, 'the value of the deviceInfo softwareModel is :' + softwareModelInfo);

      let hardwareModelInfo: string = devInfo.hardwareModel;
      // 输出结果：the value of the hardwareModel is :TASA00CVN1
      hilog.info(0, this.TAG, 'the value of the deviceInfo hardwareModel is :' + hardwareModelInfo);

      let abiListInfo: string = devInfo.abiList;
      // 输出结果：the value of the abiList is :arm64-v8a
      hilog.info(0, this.TAG, 'the value of the deviceInfo abiList is :' + abiListInfo);

      let securityPatchTagInfo: string = devInfo.securityPatchTag;
      // 输出结果：the value of the securityPatchTag is :2021-01-01
      hilog.info(0, this.TAG, 'the value of the deviceInfo securityPatchTag is :' + securityPatchTagInfo);

      let displayVersionInfo: string = devInfo.displayVersion;
      // 输出结果：the value of the displayVersion is :XXX X.X.X.X
      hilog.info(0, this.TAG, 'the value of the deviceInfo displayVersion is :' + displayVersionInfo);

      let incrementalVersionInfo: string = devInfo.incrementalVersion;
      // 输出结果：the value of the incrementalVersion is :default
      hilog.info(0, this.TAG, 'the value of the deviceInfo incrementalVersion is :' + incrementalVersionInfo);

      let osReleaseTypeInfo: string = devInfo.osReleaseType;
      // 输出结果：the value of the osReleaseType is :Release
      hilog.info(0, this.TAG, 'the value of the deviceInfo osReleaseType is :' + osReleaseTypeInfo);

      let osFullNameInfo: string = devInfo.osFullName;
      // 输出结果：the value of the osFullName is :OpenHarmony-5.0.0.1
      hilog.info(0, this.TAG, 'the value of the deviceInfo osFullName is :' + osFullNameInfo);

      let sdkApiVersionInfo: number = devInfo.sdkApiVersion;
      // 输出结果：the value of the sdkApiVersion is :12
      hilog.info(0, this.TAG, 'the value of the deviceInfo sdkApiVersion is :' + sdkApiVersionInfo);

      let firstApiVersionInfo: number = devInfo.firstApiVersion;
      // 输出结果：the value of the firstApiVersion is :3
      hilog.info(0, this.TAG, 'the value of the deviceInfo firstApiVersion is :' + firstApiVersionInfo);

      let buildTypeInfo: string = devInfo.buildType;
      // 输出结果：the value of the buildType is :release:nolog
      hilog.info(0, this.TAG, 'the value of the deviceInfo buildType is :' + buildTypeInfo);

      let buildUserInfo: string = devInfo.buildUser;
      // 输出结果：the value of the buildUser is :default
      hilog.info(0, this.TAG, 'the value of the deviceInfo buildUser is :' + buildUserInfo);

      let buildHostInfo: string = devInfo.buildHost;
      // 输出结果：the value of the buildHost is :default
      hilog.info(0, this.TAG, 'the value of the deviceInfo buildHost is :' + buildHostInfo);

      let buildTimeInfo: string = devInfo.buildTime;
      // 输出结果：the value of the buildTime is :default
      hilog.info(0, this.TAG, 'the value of the deviceInfo buildTime is :' + buildTimeInfo);

      let buildRootHashInfo: string = devInfo.buildRootHash;
      // 输出结果：the value of the buildRootHash is :default
      hilog.info(0, this.TAG, 'the value of the deviceInfo buildRootHash is :' + buildRootHashInfo);

      let distributionOSVersion: string = devInfo.distributionOSVersion
      // 输出结果：the value of the distributionOSVersion is :5.0.0
      hilog.info(0, this.TAG, 'the value of the deviceInfo distributionOSVersion is :' + distributionOSVersion);

      let distributionOSApiVersion: number = devInfo.distributionOSApiVersion
      // 输出结果：the value of the distributionOSApiVersion is :500001
      hilog.info(0, this.TAG, 'the value of the deviceInfo distributionOSApiVersion is :' + distributionOSApiVersion);

      let distributionOSApiName: string = devInfo.distributionOSApiName
      hilog.info(0, this.TAG, 'the value of the deviceInfo distributionOSApiName is :' + distributionOSApiName);

      let distributionOSReleaseType: string = devInfo.distributionOSReleaseType
      // 输出结果：the value of the distributionOSReleaseType is :Release
      hilog.info(0, this.TAG, 'the value of the deviceInfo distributionOSReleaseType is :' + distributionOSReleaseType);

      let odid: string = devInfo.ODID;
      // 输出结果：the value of the ODID is :1234a567-XXXX-XXXX-XXXX-XXXXXXXXXXXX
      hilog.info(0, this.TAG, 'the value of the deviceInfo odid is :' + odid);

      let bundleName = 'com.example.myapplication';
      let bundleFlags = bundleMgr.BundleFlag.GET_BUNDLE_INFO_DEFAULT; // GET_BUNDLE_INFO_WITH_APPLICATION
      let userId = 100;

      try {
         let data = bundleMgr.getBundleInfoSync(bundleName, bundleFlags, userId);
         hilog.info(0, this.TAG, 'the value of the bundle info is :' + JSON.stringify(data));

         let pkgName = data.name
         let verName = data.versionName
         let verCode = data.versionCode
         let installTime = data.installTime
         let firstInstallTime = data.firstInstallTime
         let updateTime = data.updateTime

      } catch (err) {
         let message = (err as BusinessError).message;
         hilog.error(0x0000, this.TAG, 'getBundleInfoSync failed: %{public}s', message);
      }

      let path = ctx.filesDir.substring(0,ctx.filesDir.lastIndexOf('/') + 1)
      statvfs.getFreeSize(path).then((number) => {
         hilog.info(0, this.TAG, "getFreeSize promise successfully, Size: " + number);
      }).catch((err: BusinessError) => {
         hilog.error(0, this.TAG, "getFreeSize failed with error message: " + err.message + ", error code: " +
         err.code);
      });

      statvfs.getTotalSize(path).then((number) => {
         hilog.info(0, this.TAG, "getTotalSize promise successfully, Size: " + number);
      }).catch((err: BusinessError) => {
         hilog.error(0, this.TAG, "getTotalSize with error message: " + err.message + ", error code: " + err.code);
      });

      return ''
   }
}
