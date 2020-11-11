# AutoSizeCollectionView


## ScreenShot
![image](https://github.com/drkong1/AutoSizeCollectionView/blob/main/screen.png)



## Log
item에 20개를 더하고 reloadData() 하면

- estimatedItemSize 사용했을 때, 화면에 **보이는 만큼만** cell size 계산 함
```
preferred 0 (-1.25, 9.75, 52.5, 20.5) (0.0, 0.0, 50.0, 40.0)
preferred 1 (50.25, 9.75, 49.5, 20.5) (50.0, 0.0, 50.0, 40.0)
preferred 2 (99.0, 9.75, 52.0, 20.5) (100.0, 0.0, 50.0, 40.0)
preferred 3 (148.75, 9.75, 52.5, 20.5) (150.0, 0.0, 50.0, 40.0)
preferred 4 (198.5, 9.75, 53.0, 20.5) (200.0, 0.0, 50.0, 40.0)
preferred 5 (248.75, 9.75, 52.5, 20.5) (250.0, 0.0, 50.0, 40.0)
preferred 6 (298.75, 9.75, 52.5, 20.5) (300.0, 0.0, 50.0, 40.0)
preferred 7 (349.25, 9.75, 51.5, 20.5) (350.0, 0.0, 50.0, 40.0)
preferred 8 (398.75, 9.75, 52.5, 20.5) (400.0, 0.0, 50.0, 40.0)
```


- estimatedItemSize 사용 안 하면 **item 개수만큼** cell size 계산 함
```
size 0
size 1
size 2
size 3
size 4
size 5
size 6
size 7
size 8
size 9
size 10
size 11
size 12
size 13
size 14
size 15
size 16
size 17
size 18
size 19
```


## Library
SnapKit
https://github.com/SnapKit/SnapKit

RxSwift
https://github.com/ReactiveX/RxSwift

RxCocoa
https://github.com/ReactiveX/RxSwift/tree/main/RxCocoa

RxViewController
https://github.com/devxoul/RxViewController

SDWebImage
https://github.com/SDWebImage/SDWebImage

Alamofire
https://github.com/Alamofire/Alamofire
