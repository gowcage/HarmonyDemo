import { EmailHelper } from "./EmailUtils";
import hilog from "@ohos.hilog";
import { fileIo as fs } from '@kit.CoreFileKit'

/*
 * Created by Gqz (gaoqizhi@hiby.com) on 2025/6/19
 */
@Entry
@Component
export struct EmailDemo {
   private readonly TAG = 'EmailDemo: ***'
   private ctx: Context = getContext(this)

   aboutToAppear(): void {
      let helper = new EmailHelper()
      helper.createClient()
         .then(async (success) => {
            if (success) {
               let zipPath = helper.getZipFilePath(this.ctx, 'email.zip')
               let files = [
                  this.ctx.filesDir + '/index-2.js',
                  this.ctx.filesDir + '/index-4.js',
                  this.ctx.filesDir + '/index-5.js',
               ]
               let complete = await helper.zipFiles(zipPath, files)
               if (complete) {
                  return helper.send('title', 'content', zipPath)
               } else {
                  return Promise.resolve(false)
               }
            } else {
               return Promise.resolve(false)
            }
         })
         .then((success) => {
            helper.close()
            // helper.getReportInfo()
         })
   }

   build() {

   }
}