import { media } from '@kit.MediaKit';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';

const TAG = 'MetaInfoDemo->: ';

@Entry
@Component
export struct MetaInfoDemo {
   // pixelMap对象声明，用于图片显示
   @State pixelMap: image.PixelMap | undefined = undefined;
   rootPath: string = getContext(this).getApplicationContext().filesDir;
   testFilename: string = '/胡彦斌 - 月光.flac';
   testFilename2: string = '/爱人错过_告五人.mp3'

   build() {
      Row() {
         Column() {
            Button() {
               Text('TestButton')
                  .fontSize(30)
                  .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin({
               top: 20
            })
            .backgroundColor('#0D9FFB')
            .width('60%')
            .height('5%')
            .onClick(() => {
               // 设置fdSrc, 获取音频元数据和专辑封面（异步接口以Callback形式调用）
               // this.testFetchMetadataFromFdSrcByCallback();
               // 设置fdSrc, 获取音频元数据和专辑封面（异步接口以Promise形式调用）
               this.testFetchMetadataFromFdSrcByPromise();
               // 通过fdSrc获取沙箱路径下音频元数据和专辑封面（文件必须在沙箱路径里存在）
               // this.testFetchMetadataFromFdSrc();
               // 设置dataSrc, 获取沙箱路径下音频元数据和专辑封面（文件必须在沙箱路径里存在）
               // this.testFetchMetadataFromDataSrc();
            })

            Image(this.pixelMap).width(300).height(300)
               .margin({
                  top: 20
               })
         }
         .width('100%')
      }
      .height('100%')
   }

   // 在以下demo中，使用资源管理接口获取打包在HAP内的媒体资源文件，通过设置fdSrc属性，获取音频元数据并打印，
   // 获取音频专辑封面并通过Image控件显示在屏幕上。该demo以Callback形式进行异步接口调用
   async testFetchMetadataFromFdSrcByCallback() {
      if (canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor")) {
         // 创建AVMetadataExtractor对象
         let avMetadataExtractor: media.AVMetadataExtractor = await media.createAVMetadataExtractor();

         // copy rawfile to sandbox
         /*getContext(this).resourceManager.getRawFileContent('audio/胡彦斌 - 月光.flac', (_err, value) => {
            let myBuffer: ArrayBufferLike = value.buffer;
            let context = getContext(this); //沙箱路径
            let filePath = context.filesDir + '/test.txt';
            console.info('testTag-filePath:' + filePath);
            let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            let writeLen = fs.writeSync(file.fd, myBuffer);
            console.info('testTag-write data to file succeed and size is:' + writeLen);
            fs.closeSync(file);
         });*/

         // 设置fdSrc
         avMetadataExtractor.fdSrc = await getContext(this).resourceManager.getRawFd('audio/胡彦斌 - 月光.flac');

         // 获取元数据（callback模式）
         avMetadataExtractor.fetchMetadata((error, metadata) => {
            if (error) {
               console.error(TAG, `fetchMetadata callback failed, err = ${JSON.stringify(error)}`);
               return;
            }
            console.info(TAG, `fetchMetadata callback success, genre: ${metadata.genre}`);
         })

         //获取专辑封面（callback模式）
         avMetadataExtractor.fetchAlbumCover((err, pixelMap) => {
            if (err) {
               console.error(TAG, `fetchAlbumCover callback failed, err = ${JSON.stringify(err)}`);
               return;
            }
            this.pixelMap = pixelMap;

            // 释放资源（callback模式）
            avMetadataExtractor.release((error) => {
               if (error) {
                  console.error(TAG, `release failed, err = ${JSON.stringify(error)}`);
                  return;
               }
               console.info(TAG, `release success.`);
            })
         })
      }
   }

   // 在以下demo中，使用资源管理接口获取打包在HAP内的媒体资源文件，通过设置fdSrc属性，获取音频元数据并打印，
   // 获取音频专辑封面并通过Image控件显示在屏幕上。该demo以Promise形式进行异步接口调用
   async testFetchMetadataFromFdSrcByPromise() {
      if (canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor")) {
         // 创建AVMetadataExtractor对象
         let avMetadataExtractor: media.AVMetadataExtractor = await media.createAVMetadataExtractor();
         // 设置fdSrc
         avMetadataExtractor.fdSrc = await getContext(this).resourceManager.getRawFd('audio' + this.testFilename);

         // 获取元数据（promise模式）
         let metadata = await avMetadataExtractor.fetchMetadata();
         console.info(TAG, `get meta data, hasAudio: ${JSON.stringify(metadata)}`);

         // 获取专辑封面（promise模式）
         this.pixelMap = await avMetadataExtractor.fetchAlbumCover();

         // 释放资源（promise模式）
         avMetadataExtractor.release();
         console.info(TAG, `release success.`);
      }
   }

   // 在以下demo中，使用fs文件系统打开沙箱地址获取媒体文件地址，设置fdSrc属性，获取音频元数据并打印，
   // 获取音频专辑封面并通过Image控件显示在屏幕上。
   async testFetchMetadataFromFdSrc() {
      if (canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor")) {
         // 创建AVMetadataExtractor对象
         let avMetadataExtractor = await media.createAVMetadataExtractor();


         // 设置fdSrc
         avMetadataExtractor.fdSrc = fs.openSync(this.rootPath + this.testFilename);

         // 获取元数据（promise模式）
         let metadata = await avMetadataExtractor.fetchMetadata();
         console.info(TAG, `get meta data, mimeType: ${metadata.mimeType}`);

         // 获取专辑封面（promise模式）
         this.pixelMap = await avMetadataExtractor.fetchAlbumCover();

         // 释放资源（promise模式）
         avMetadataExtractor.release();
         console.info(TAG, `release data source success.`);
      }
   }

   // 在以下demo中，使用fs文件系统打开沙箱地址获取媒体文件地址，设置dataSrc属性，获取音频元数据并打印，
   // 获取音频专辑封面并通过Image控件显示在屏幕上。
   async testFetchMetadataFromDataSrc() {
      let context = getContext(this) as common.UIAbilityContext;
      // 通过UIAbilityContext获取沙箱地址filesDir（以Stage模型为例）
      let fd: number = fs.openSync(this.rootPath + this.testFilename).fd;
      let fileSize: number = fs.statSync(this.rootPath + this.testFilename).size;
      // 设置dataSrc描述符，通过callback从文件中获取资源，写入buffer中
      let dataSrc: media.AVDataSrcDescriptor = {
         fileSize: fileSize,
         callback: (buffer, len, pos) => {
            if (buffer == undefined || len == undefined || pos == undefined) {
               console.error(TAG, `dataSrc callback param invalid`);
               return -1;
            }
            let options: ReadOptions = {
               offset: pos,
               length: len
            };
            let num = fs.readSync(fd, buffer, options);
            console.info(TAG, 'readAt end, num: ' + num);
            if (num > 0 && fileSize >= pos) {
               return num;
            }
            return -1;
         }
      };

      if (canIUse("SystemCapability.Multimedia.Media.AVMetadataExtractor")) {
         // 创建AVMetadataExtractor对象
         let avMetadataExtractor = await media.createAVMetadataExtractor();
         // 设置dataSrc
         avMetadataExtractor.dataSrc = dataSrc;

         // 获取元数据（promise模式）
         let metadata = await avMetadataExtractor.fetchMetadata();
         console.info(TAG, `get meta data, mimeType: ${metadata.mimeType}`);

         // 获取专辑封面（promise模式）
         this.pixelMap = await avMetadataExtractor.fetchAlbumCover();

         // 释放资源（promise模式）
         avMetadataExtractor.release();
         console.info(TAG, `release data source success.`);
      }
   }
}