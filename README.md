
![%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-01-01_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10 30 10](https://user-images.githubusercontent.com/106153549/210175813-8ebd0ee1-03ee-4ba3-b6d5-961e96b6f0ca.png)

![%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-01-01_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10 30 18](https://user-images.githubusercontent.com/106153549/210175827-86ab1256-89a7-4b0c-bbd0-0e23ec17a503.png)


![Jan-02-2023 00-36-27](https://user-images.githubusercontent.com/106153549/210176446-99519e8b-5a51-4625-8078-61eb5c9b0fb3.gif)

<br/>

## ๐ฑ ์ฑ ์๊ฐ

- ๋ด๊ฐ ์ข์ํ๋ ์ํ๋ฅผ ๊ฒ์ ํ ์ฆ๊ฒจ์ฐพ๊ธฐ์ ์ ์ฅํ  ์ ์๋ ์ฑ
    - ์ํ ๊ฒ์์ ํ  ์ ์๋ ์ํ๊ฒ์ ํญ
    - ๋ด๊ฐ ์ฆ๊ฒจ์ฐพ๊ธฐ๋ก ์ ์ฅํ ์ํ๋ฅผ ํ์ธํ  ์ ์๋ ์ฆ๊ฒจ์ฐพ๊ธฐ ํญ
    - ์ํ ๊ฒ์ ํ ์ด๋ฏธ ์ฆ๊ฒจ์ฐพ๊ธฐ์ ์ ์ฅ๋์ด ์์ผ๋ฉด ๋ถ๋งํฌ ํ์
    
- ์ํ์ ๋ณด(omdb) API + **URLRequestConvertible**๋ฅผ ํ์ฉํ **๋น๋๊ธฐ ํต์ **
- Realm์ ํ์ฉํ **Local data CRUD**
- **RxdataSource**๋ฅผ ์ด์ฉํ CollectionView item ๊ตฌ์ฑ
- CollectionView Scroll์ ๋ง์ง๋ง์ ๋๋ฌํ์ ๋ **Pagination** ๊ธฐ๋ฅ ๊ตฌํ

<br/>

## ๐ ์ฌ์ฉ ๊ธฐ์  ์คํ

- ํ๋ฉด ๊ตฌ์ฑ : `Swift`, `UIkit`, `Snapkit`, `Then`
- ๋์์ธ ํจํด : `MVVM`, `Singleton`
- ๋ฐ์ดํฐ ํต์  : `Alamofire`, `Router`, `URLRequestConvertible`
- Rx : , `RxSwift`, `RxCocoa`, `RxdataSource`
- DB : `RealmSwift`
- ๊ธฐํ :  `JGProgressHUD`, `Kingfisher`

<br/>

## ๐ฅ Trouble Shooting

- **UIImage(systemName: )์ iOS 13.0+ ์์๋ง ์ง์ํจ.**
    - iOS 12.0+์๊ธฐ ๋๋ฌธ์ SF Symbol์ ์์ด์ฝ์ ์ง์  ๋ค์ด๋ฐ์ UIImage(named:)๋ก ์ฌ์ฉํจ.
    
    <br/>
    
- **Cell์์ API ํธ์ถ์ด๋ CollectionView Rx๋ฅผ ์ด์ฉํด ๋ฐ์ดํฐ๋ฅผ ๋ถ๋ฌ์์ผ ํ  ๊ฒฝ์ฐ Cell ์์ฒด์disposebag์ ํธ์ถํด์ค์ผํจ.**
    - ๋ง์ฝ ViewController์ disposebag์ ์ฌ์ฉํ๋ฉด ํด๋ฆญ์ด ๋ ๋ฒ ๋๋ค๋์ง ์ค๋ฅ๊ฐ ๋ฐ์.
    
    <br/>

- **Api ํต์ (requestMovies)์ ์ด์**
    - ๋น๋๊ธฐ์ฒ๋ฆฌ ๋ฌธ์ ๋ฅผ ํด๊ฒฐํ๊ธฐ ์ํด์ Observable<[]>์ ์ฌ์ฉํจ.

```swift
func requestMovies(title: String, page: Int) -> Observable<[MovieDetail]> {
        
        return Observable<[MovieDetail]>.create { observer in
            MovieAPIService.shared.requestMovieAPI(type: MovieDTO.self, router: MovieRouter.search(title: title, page: "\(page)")) { result in
                switch result {
                case .success(let success):
                    observer.onNext(success.movieDetails)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.observe(on: SerialDispatchQueueScheduler(qos: .background))
```

<br/>

- **rx.itemSelected vs rx.modelSelected(T.type) ์ ์ฐจ์ด**
    - `itemSelected`์์ฑ์ ControlEvent<Void>์ผ๋ก indexPath ๊ฐ๋ง ๋ด๋ ค์ค.
    - item ์์ฒด๊ฐ ํ์ํ๊ธฐ ๋๋ฌธ์ `modelSelected` ๋ฅผ ์ฌ์ฉํจ.
    
    ```swift
    mainView.collectionView.rx.modelSelected(MovieDetail.self)
                .observe(on: MainScheduler.instance)
                .subscribe { data in
                    let movie = data.element
    								...
                    // ์ฆ๊ฒจ์ฐพ๊ธฐ Alert ๋ณด์ฌ์ฃผ๊ธฐ
    								...
                }.disposed(by: disposeBag)
    ```
    
    <br/>

- ๋น์ง๋์ค์ ์ธ ๋ก์ง์ ViewModel์์ .observe(on: SerialDispatchQueueScheduler(qos: .background))๋ฅผ ์ด์ฉํด **background Thread**์์ ์คํํ๊ณ  ViewController์์๋ ํญ์ **Main Thread**์์ ๋์ํ๊ฒ ํจ.
    - **Thread-Safe ํ๊ฒ ํ๊ธฐ ์ํด**
    
    <br/>

- **Realm์ ๋ํ ๋ฐ์ดํฐ ์ฒ๋ฆฌ๋ Background์์ ์ฒ๋ฆฌ๊ฐ ์๋๋ค๋๊ฑธ ์.**
    - Main Thread์์ ์ฒ๋ฆฌํด์ค.
    
    <br/>

- **Observable.merge(input.viewWillAppearEvent, input.triggerEvent)**
    - BookmarkVC์์ ViewWillAppear์ ์ฆ๊ฒจ์ฐพ๊ธฐ๊ฐ ์ ๊ฑฐ ๋์์ ๋ ๋ ๋ฒ ViewModel์ ๋ณํ๋ฅผ ์๋ ค์ฃผ์ด์ผ ํ์. ๋ ๊ฐ์ง ๊ฒฝ์ฐ์ ๊ฐ์ ๋์์ ํด์ merge๋ฅผ ์ด์ฉํด ํ๋์ Stream์์ ์ฒ๋ฆฌํจ.
    
    ```swift
    Observable.merge(input.viewWillAppearEvent, input.triggerEvent)
            .observe(on: MainScheduler.instance) // Main Thread
            .subscribe { _ in
                ...
                // [MovieData] -> [MovieDetail]            
    						...
            }.disposed(by: disposeBag)
    ```
    
    <br/>

- **title์ด๋ page๊ฐ ๋ณํ๋ฉด API ํธ์ถ์ ํด์ผํด์ combineLatest๋ฅผ ์ด์ฉํด ํ๋์ Stream์์ ์ฒ๋ฆฌํจ.**

```swift
//combineLatest๋ก ํฉ์น๊ธฐ
Observable.combineLatest(input.titleSubject, input.pageSubject)
      .observe(on: SerialDispatchQueueScheduler(qos: .background))
      .flatMap { 
					//api ํธ์ถ
      }
      .subscribe { movieDetails in
          //๊ฒฐ๊ณผ ๊ฐ ๋ด์์ฃผ๊ธฐ
      }.disposed(by: disposeBag)
```

<br/>

- **์ปฌ๋ ์ ๋ทฐ ๊ฒ์ ํ ์คํฌ๋กค ๋งจ ์๋ก ์ฌ๋ฆฌ๋ ๊ธฐ๋ฅ**
    - CollectionView์ **setContentOffset**๋ฅผ ์ด์ฉํด ๋งจ ์๋ก ์ฌ๋ ค์ค.

```swift
vc.mainView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
```

<br/>

- **CollectionView Pagination ๊ธฐ๋ฅ ๊ตฌํ**
    - ์ปฌ๋ ์ ๋ทฐ์ ๋งจ ๋ฐ์ ๋๋ฌํ์ ๋, page์ 1์ ๋ํด์ฃผ๊ณ  pageSubject์ onNext๋ก ๊ฐ์ ๋ฃ์ด์ค.
    - ๋ง์ฝ ๋ค๋ฅธ ์ํ๋ฅผ ๊ฒ์ํ์ ๋๋ page๋ฅผ 1๋ก ์ด๊ธฐํ ์์ผ์ฃผ๊ณ  title๊ณผ page์ ๋ฐ๋ฅธ ์ํ ๊ฒ์ ๊ฒฐ๊ณผ ๊ฐ ๋ณด์ฌ์ค.

```swift
mainView.collectionView.rx.didScroll
        .observe(on: MainScheduler.instance)
        .withUnretained(self)
        .subscribe { vc, _ in
            if vc.mainView.collectionView.contentOffset.y == (self.mainView.collectionView.contentSize.height - self.mainView.collectionView.bounds.size.height) {
                self.page += 1
                input.pageSubject.onNext(self.page)
            }
        }.disposed(by: disposeBag)

//๊ฒ์ ๋ฒํผ ํด๋ฆญ ์
input.searchButtonTap
        .observe(on: MainScheduler.instance)
        .withUnretained(self)
        .subscribe(onNext: { vc, _ in
            vc.hud.show(in: self.mainView)
            input.titleSubject.onNext(self.mainView.searchBar.text ?? "")
            self.page = 1
            input.pageSubject.onNext(self.page)
            vc.hud.dismiss(animated: true)
            vc.mainView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            vc.mainView.searchBar.endEditing(true)
        }).disposed(by: disposeBag)
```

<br/>

- **Realm์ ์ด์ฉํ ์ฆ๊ฒจ์ฐพ๊ธฐ ์ ๊ฑฐํ๊ธฐ**
    - ์ํ์ ๋ณด์ค imdbID์ ๊ฐ์ ์ด์ฉํด์ Realm์ ์ ์ฅ๋ Id์ ์ํ์ ๋ณด์ Id๋ฅผ ๋น๊ตํด์ ๊ฐ์ผ๋ฉด ์ญ์ ํด์ค.

```swift
try! self.repository.localRealm.write({
    let selectedMovie = self.repository.localRealm.objects(MovieData.self).where {
        $0.imdbId == movie?.imdbID ?? ""
    }
    self.repository.localRealm.delete(selectedMovie)
})
```

<br/>

- **Realm์ ์ด์ฉํ ๋ถ๋งํฌ ํ์ํด์ฃผ๊ธฐ**
    - ์ํ๋ฅผ ์ฆ๊ฒจ์ฐพ๊ธฐ ์ถ๊ฐ๋ฅผ ํ๊ณ  ๋๋ฉด ๋ถ๋งํฌ ํ์๊ฐ ๋๋ ๊ธฐ๋ฅ
    - ์ฆ๊ฒจ์ฐพ๊ธฐ ๋์ด ์๋ ์ํ ์ ๋ณด ๋ฐฐ์ด์ ๋ฐ์์ด โ ๋ฐฐ์ด ์ค imdbId๊ฐ Cell์ id์ ๊ฐ์์ง ๋น๊ตํด์ element๋ฅผ ๊ฐ์ ธ์ด โ ๊ทธ ์์ด ์ฆ๊ฒจ์ฐพ๊ธฐ๊ฐ ๋์ด ์์ผ๋ฉด ๋ถ๋งํฌ ํ์๋ฅผ ํด์ค.
    
    ```swift
    //CollectionViewCell์ override init() ๋  ๋ ๊ทธ๋ ค์ฃผ์๋ค.
    self?.tasks = self?.repository.localRealm.objects(MovieData.self)
    self?.isBookmarkedMovies = self?.tasks.where {
    $0.isBookmarked == true
    }
    let movie = self?.isBookmarkedMovies.filter{ movieData in
        movieData.imdbId == self?.id
    }.first
    if movie?.isBookmarked == true {
        self?.isBookmarkedButton.setImage(UIImage(named: "bookmark.fill"), for: .normal)
    }
    ```
