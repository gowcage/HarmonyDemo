@Component
export struct TransitionComp {
   @State flag: boolean = true;

   build() {
      Column() {
         Button().width(80).height(30).margin(30)
            .onClick(() => {
               // 点击Button控制Image的显示和消失
               this.flag = !this.flag;
            })
         // if (this.flag) {
            // Image的显示和消失配置为相同的过渡效果（出现和消失互为逆过程）
            // 出现时从指定的透明度为0、绕z轴旋转180°的状态，变为默认的透明度为1、旋转角为0的状态，透明度与旋转动画时长都为2000ms
            // 消失时从默认的透明度为1、旋转角为0的状态，变为指定的透明度为0、绕z轴旋转180°的状态，透明度与旋转动画时长都为2000ms
            Image($r('app.media.startIcon')).width(200).height(200).visibility(this.flag ? Visibility.Visible : Visibility.Hidden)
               .transition(TransitionEffect.OPACITY.animation({ duration: 1000, curve: Curve.Ease }).combine(
                  TransitionEffect.move(TransitionEdge.BOTTOM)
               ))
         // }
      }.width('100%')
   }
}