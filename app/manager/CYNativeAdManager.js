export default class CYNativeAdManager {
    loaderMap = {}
    component
    constructor(component) {
        this.component = component
        console.log("sambowaaa, component = " + this.component.constructor.name)
    }

    initAdUnitId(adUnitId, count) {
        console.log("sambowaaa, adUnitId = " + adUnitId)
        console.log("sambowaaa, count = " + count)
        if (this.loaderMap[adUnitId + count] == undefined) {
            console.log("sambowaaa, undefined = " + this.loaderMap[adUnitId])
            this.loaderMap[adUnitId] = count
        }
        console.log("sambowaaa, at least = " + this.loaderMap[adUnitId])
    }
}