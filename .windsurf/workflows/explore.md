---
description: สร้างฟีเจอร์ Explore/Discovery สำหรับโปรเจกต์ Flutter Clean Architecture
---

# Explore Feature Workflow
เมื่อถูกเรียกใช้คำสั่งนี้ ให้ทำตามขั้นตอนการพัฒนาฟีเจอร์ Explore สำหรับโปรเจกต์ Flutter Clean Architecture:

1. **Domain Layer:** สร้าง Entity และ UseCase สำหรับ Explore
   - สร้าง Entity ที่เกี่ยวข้อง เช่น `Category`, `FeaturedMusic`, `SearchResult`
   - สร้าง `ExploreRepository` (abstract) ใน `lib/app/domain/repositories/`
   - สร้าง UseCase เช่น `GetCategoriesUseCase`, `SearchMusicUseCase` ใน `lib/app/domain/usecases/`

2. **Data Layer:** สร้าง Repository Implementation และเชื่อมต่อ API
   - สร้าง `ExploreRepositoryImpl` ใน `lib/app/data/repositories/`
   - เพิ่ม endpoint ใน `lib/app/core/constants/api_endpoints.dart`
   - ใช้ `ApiClient` ที่มีอยู่แล้วในการยิง API

3. **Presentation Layer:** สร้างหน้า UI และ Controller
   - สร้าง `ExploreController extends GetxController with ErrorHandlerMixin` ใน `lib/app/features/explore/controllers/`
   - สร้าง `ExplorePage` ใน `lib/app/features/explore/presentation/`
   - สร้าง `ExploreBinding` ใน `lib/app/features/explore/bindings/`
   - เพิ่ม route `/explore` ใน `lib/app/routes/app_routes.dart` และ `lib/app/routes/app_pages.dart` พร้อม `AuthMiddleware()`

4. **Testing:** เขียน Widget Test และ Unit Test
   - เขียน Widget Test สำหรับ `ExplorePage` ใน `test/explore_page_test.dart`
   - ใช้ `FakePlayerController`, `FakeTokenStorage`, `FakeCrashlyticsService` จาก `test/fakes.dart`
   - Register `AuthService` และ set `isLoggedIn = true` ใน setUp
