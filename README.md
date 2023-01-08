
![%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-01-01_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10 30 10](https://user-images.githubusercontent.com/106153549/210175813-8ebd0ee1-03ee-4ba3-b6d5-961e96b6f0ca.png)

![%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-01-01_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_10 30 18](https://user-images.githubusercontent.com/106153549/210175827-86ab1256-89a7-4b0c-bbd0-0e23ec17a503.png)


![Jan-02-2023 00-36-27](https://user-images.githubusercontent.com/106153549/210176446-99519e8b-5a51-4625-8078-61eb5c9b0fb3.gif)

<br/>

## 📱 앱 소개

- 내가 좋아하는 영화를 검색 후 즐겨찾기에 저장할 수 있는 앱
    - 영화 검색을 할 수 있는 영화검색 탭
    - 내가 즐겨찾기로 저장한 영화를 확인할 수 있는 즐겨찾기 탭
    - 영화 검색 후 이미 즐겨찾기에 저장되어 있으면 북마크 표시
    
- 영화정보(omdb) API + **URLRequestConvertible**를 활용한 **비동기 통신**
- Realm을 활용한 **Local data CRUD**
- **RxdataSource**를 이용한 CollectionView item 구성
- CollectionView Scroll시 마지막에 도달했을 때 **Pagination** 기능 구현

<br/>

## 📖 사용 기술 스택

- 화면 구성 : `Swift`, `UIkit`, `Snapkit`, `Then`
- 디자인 패턴 : `MVVM`, `Singleton`
- 데이터 통신 : `Alamofire`, `Router`, `URLRequestConvertible`
- Rx : , `RxSwift`, `RxCocoa`, `RxdataSource`
- DB : `RealmSwift`
- 기타 :  `JGProgressHUD`, `Kingfisher`

<br/>

## 💥 Trouble Shooting

- **UIImage(systemName: )은 iOS 13.0+ 에서만 지원함.**
    - iOS 12.0+였기 때문에 SF Symbol의 아이콘을 직접 다운받아 UIImage(named:)로 사용함.
    
    <br/>
    
- **Cell에서 API 호출이나 CollectionView Rx를 이용해 데이터를 불러와야 할 경우 Cell 자체의disposebag을 호출해줘야함.**
    - 만약 ViewController의 disposebag을 사용하면 클릭이 두 번 된다던지 오류가 발생.
    
    <br/>

- **Api 통신(requestMovies)의 이슈**
    - 비동기처리 문제를 해결하기 위해서 Observable<[]>을 사용함.

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

- **rx.itemSelected vs rx.modelSelected(T.type) 의 차이**
    - `itemSelected`속성은 ControlEvent<Void>으로 indexPath 값만 내려줌.
    - item 자체가 필요했기 때문에 `modelSelected` 를 사용함.
    
    ```swift
    mainView.collectionView.rx.modelSelected(MovieDetail.self)
                .observe(on: MainScheduler.instance)
                .subscribe { data in
                    let movie = data.element
    								...
                    // 즐겨찾기 Alert 보여주기
    								...
                }.disposed(by: disposeBag)
    ```
    
    <br/>

- 비지니스적인 로직은 ViewModel에서 .observe(on: SerialDispatchQueueScheduler(qos: .background))를 이용해 **background Thread**에서 실행하고 ViewController에서는 항상 **Main Thread**에서 동작하게 함.
    - **Thread-Safe 하게 하기 위해**
    
    <br/>

- **Realm에 대한 데이터 처리는 Background에서 처리가 안된다는걸 앎.**
    - Main Thread에서 처리해줌.
    
    <br/>

- **Observable.merge(input.viewWillAppearEvent, input.triggerEvent)**
    - BookmarkVC에서 ViewWillAppear와 즐겨찾기가 제거 되었을 때 두 번 ViewModel에 변화를 알려주어야 했음. 두 가지 경우에 같은 동작을 해서 merge를 이용해 하나의 Stream에서 처리함.
    
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

- **title이나 page가 변하면 API 호출을 해야해서 combineLatest를 이용해 하나의 Stream에서 처리함.**

```swift
//combineLatest로 합치기
Observable.combineLatest(input.titleSubject, input.pageSubject)
      .observe(on: SerialDispatchQueueScheduler(qos: .background))
      .flatMap { 
					//api 호출
      }
      .subscribe { movieDetails in
          //결과 값 담아주기
      }.disposed(by: disposeBag)
```

<br/>

- **컬렉션 뷰 검색 후 스크롤 맨 위로 올리는 기능**
    - CollectionView의 **setContentOffset**를 이용해 맨 위로 올려줌.

```swift
vc.mainView.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
```

<br/>

- **CollectionView Pagination 기능 구현**
    - 컬렉션 뷰의 맨 밑에 도달했을 때, page에 1을 더해주고 pageSubject에 onNext로 값을 넣어줌.
    - 만약 다른 영화를 검색했을 때는 page를 1로 초기화 시켜주고 title과 page에 따른 영화 검색 결과 값 보여줌.

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

//검색 버튼 클릭 시
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

- **Realm을 이용한 즐겨찾기 제거하기**
    - 영화정보중 imdbID의 값을 이용해서 Realm에 저장된 Id와 영화정보의 Id를 비교해서 같으면 삭제해줌.

```swift
try! self.repository.localRealm.write({
    let selectedMovie = self.repository.localRealm.objects(MovieData.self).where {
        $0.imdbId == movie?.imdbID ?? ""
    }
    self.repository.localRealm.delete(selectedMovie)
})
```

<br/>

- **Realm을 이용한 북마크 표시해주기**
    - 영화를 즐겨찾기 추가를 하고 나면 북마크 표시가 되는 기능
    - 즐겨찾기 되어 있는 영화 정보 배열을 받아옴 → 배열 중 imdbId가 Cell의 id와 같은지 비교해서 element를 가져옴 → 그 셀이 즐겨찾기가 되어 있으면 북마크 표시를 해줌.
    
    ```swift
    //CollectionViewCell에 override init() 될 때 그려주었다.
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
