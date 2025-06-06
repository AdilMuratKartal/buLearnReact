// src/store/uiSlice.js
import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  isOpen: false,        // Sidebar açık/kapalı durumu
  isMobile: null,       // 900px aşağısındamı bakar
  headerHeight: 0,      // Header bileşen yüksekliği
  selectedIndex: 0,     // Seçilen menü indeks
  themeMode: 'light',   // Tema modu: 'light' veya 'dark'
  userRole: 'user'      // Kullanıcı rolü: 'admin', 'user', 'mentor' vb.
};

const uiSlice = createSlice({
  name: 'ui',
  initialState,
  reducers: {
    toggleSidebar(state) {
      state.isOpen = !state.isOpen;
    },
    setHeaderHeight(state, action) {
      state.headerHeight = action.payload;
    },
    setSelectedIndex(state, action) {
      state.selectedIndex = action.payload;
    },
    setThemeMode(state, action) {
      state.themeMode = action.payload;
    },
    setUserRole(state, action) {
      state.userRole = action.payload;
    },
    setIsMobile(state,action) {
        state.isMobile = action.payload;
    }
  }
});

export const {
  toggleSidebar,
  setHeaderHeight,
  setSelectedIndex,
  setThemeMode,
  setUserRole,
  setIsMobile
} = uiSlice.actions;

export default uiSlice.reducer;