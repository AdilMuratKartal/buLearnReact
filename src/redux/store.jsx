import { configureStore } from '@reduxjs/toolkit'
import {
  persistStore,
  persistReducer,
  FLUSH,
  REHYDRATE,
  PAUSE,
  PERSIST,
  PURGE,
  REGISTER,
} from 'redux-persist'
import storage from 'redux-persist/lib/storage'  // localStorage için
import userReducer from './slices/userSlice'
import uiReducer from './slices/uiSlice';

// 1.1 Persist konfigürasyonu
const persistConfig = {
  key: 'user',          // storage altında kullanılacak key
  storage,              // hangi storage, burada localStorage
  whitelist: ['userCourseData','token'],  // sadece bu alanlar persist edilsin
  // blacklist: ['loading','error']  // tersini isterseniz
}

// 1.2 Persisted reducer oluştur
const persistedUserReducer = persistReducer(persistConfig, userReducer)

// 1.3 Store’u configure ederken middleware’i de ayarlayın
export const store = configureStore({
  reducer: {
    user: persistedUserReducer,
    ui: uiReducer,
    // ... varsa diğer slice’lar
  },
  middleware: getDefaultMiddleware =>
    getDefaultMiddleware({
      serializableCheck: {
        // redux-persist aksiyonlarını serileştirme hatası verme
        ignoredActions: [FLUSH, REHYDRATE, PAUSE, PERSIST, PURGE, REGISTER],
      },
    }),
})

// 1.4 Persistor’ı export edin
export const persistor = persistStore(store)