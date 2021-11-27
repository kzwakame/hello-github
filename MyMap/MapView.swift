//
//  MapView.swift
//  MyMap
//
//  Created by 岩永和史 on 2021/11/23.
//

import SwiftUI
//マップを表示させるための
import MapKit

//①　ContentViewからMapViewが実行されると、「struct MapView:~』が実行される
struct MapView: UIViewRepresentable {
    
    //検索キーワード
    //② serchKeyプロパティに『東京タワー』がセットされる
    let searchKey: String
    
    //マップ種類
    let mapType: MKMapType
    
    //表示するViewを作成する時に実行
    //③ View(画面)を表示する最初の一回だけ、makeUIViewメソッドが実行される
    func makeUIView(context: Context) -> MKMapView {
        
        //MKMapViewのインスタンス生成
        //④ MKMapViewクラスのインスタンスを行い、マップが表示される
        MKMapView()
        
    }//makeUIViewここまで
    
    //表示したViewが更新されるたびに実行
    /*
     ⑤ Viewが更新されるたびupdateUIViewメソッドが実行される。
     最初にViewが表示されることもある。
     */
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        //入力された文字をデバッグエリアに表示
        //⑥ print文でデバッグエリアに「東京タワー」と出力する。
        print(searchKey)
        
        //マップ種類の設定
        uiView.mapType = mapType
        
        //CLGeocoderインスタンスを取得
        //CLGeocoderクラスを使うと、緯度経度から住所を検索することができる。
        //また、住所から緯度経度を検索することもできる。
        let geocoder = CLGeocoder()
        
        //入力された文字から位置情報を取得
        //第一引数 addressString 検索したい場所を記述した文字列
        //第二引数 completionHandler 結果と一緒に実行するまとまった処理(クロージャ)
        //placemarks 取得した位置情報が格納される、複数の位置情報を格納できる
        //error　取得時のエラーが格納される
        geocoder.geocodeAddressString(searchKey , completionHandler: {
            (placemarks,error) in
                //リクエストの結果が存在し、1件目の情報から位置情報を取り出す
                //placemarks(オプショナル型 nilを許容)を変数に格納することで
                //アンラップ(nilでない値を取り出して確認)している
                if let unwrapPlacemarks = placemarks ,
                   
                    //.first 先頭の配列を取り出せる
                   //.firstもオプショナル型なので、アンラップして取り出す
                    //unwrapPlacemarks 複数の位置情報が格納されている配列
                    //firstPlacemark unwrapPlacemarksの先頭の配列を格納
                    let firstPlacemark = unwrapPlacemarks.first ,
                   
                    //.locationもオプショナル型なので、アンラップして取り出す
                   //location firstPlacemarkの緯度・経度・高度などの情報を格納
                    let location = firstPlacemark.location {
                    
                    //位置情報から緯度経度をtargetCoordinateに取り出す
                    //.coordinate 緯度経度が格納されている変数
                    //targetCoordinate 緯度経度を格納
                    let targetCoordinate = location.coordinate
                    
                    //緯度軽度をデバッグエリアに表示
                    print(targetCoordinate)
                    
                    //MKPointAnnotationインスタンスを取得し、ピンを生成
                    //MKPointAnnotation　ピンを置くための機能が利用できる
                    let pin = MKPointAnnotation()
                    
                    //ピンを置く場所に緯度経度を設定
                    //coordinateプロパティでピンを置く座標点を設定できる
                    pin.coordinate = targetCoordinate
                    
                    //ピンのタイトルを設定
                    //titleプロパティで検索キーワードを表示できる
                    pin.title = searchKey
                    
                    //ピンを地図に置く
                    uiView.addAnnotation(pin)
                    
                    //緯度経度を中心にして半径500mの範囲を表示
                    //ピンを置いた場所にマップの表示位置を移動する
                    //MKCoordinateRegionメソッド 中心位置(緯度経度)と縦横の表示する幅(メートル単位)を指定できる
                    uiView.region = MKCoordinateRegion(
                        center: targetCoordinate,
                        latitudinalMeters: 500.0,
                        longitudinalMeters: 500.0)
                    
                } // if ここまで
                
            }) // geocoder ここまで
        
    }//updateUIViewここまで
    
}//MapViewここまで


//Canvasに描画している場合のみ実行(シミュレータでアプリを起動させたときは実行されない)
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        //プレビュー用として、初期値 東京タワーをセット
        MapView(searchKey: "東京タワー", mapType: .standard)
    }
}
