import fs from '@ohos.file.fs';
import hilog from '@ohos.hilog';
import { Context } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';

let TAG = 'hiby: ***CopyDemo'

export function isExist(path: string): boolean {
   return fs.accessSync(path, fs.AccessModeType.EXIST);
}

export function copyRawFile(rawFilePath: string, targetPath: string,targetName:string, rm: resourceManager.ResourceManager) {
   let rawFileName =
      rawFilePath.lastIndexOf('/') > 0 ? rawFilePath.substring(rawFilePath.lastIndexOf('/') + 1) : rawFilePath;
   let rawFileDir = rawFilePath.lastIndexOf('/') > 0 ? rawFilePath.substring(0, rawFilePath.lastIndexOf('/')) : '';
   let dirPath = targetPath + '/' + rawFileDir;
   let filePath = dirPath + '/' + targetName;

   // check targetPath exists
   if (!isExist(dirPath)) {
      try {
         fs.mkdirSync(dirPath, true)
      } catch (e) {
         hilog.error(0, TAG, '', e)
      }
   }

   try {
      let rawFile = rm.getRawFdSync(rawFilePath)
      let destFile = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);

      let rawSize = rawFile.length

      let buffSize = 8192, off = 0
      const buffer = new ArrayBuffer(buffSize);
      while (true) {
         let readLen = rawFile.length - off > buffSize ? buffSize : rawFile.length - off;
         const len = fs.readSync(rawFile.fd, buffer, {
            offset: rawFile.offset + off,
            length: readLen/*buffSize*/
         });

         if (len <= 0) {
            break;
         }
         let ret = fs.writeSync(destFile.fd, buffer, { offset: off, length: len });
         off += len;
      }

      fs.closeSync(destFile.fd);
      rm.closeRawFdSync(rawFilePath)

      if(off != rawSize){
         throw new Error('copyRawFile failed! size is not equal')
      }
   } catch (e) {
      hilog.error(0, TAG, '', e)
   }

}


