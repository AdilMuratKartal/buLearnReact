// components/Header/LanguageMenu.jsx
import React from 'react';
import { Menu, MenuItem } from '@mui/material';

const LanguageMenu = ({ anchorEl, open, onClose }) => (
  <Menu anchorEl={anchorEl} open={open} onClose={onClose}>
    {["English", "Türkçe", "中文", "日本語", "Deutsch", "Français", "Español", "Русский"].map((lang, i) => (
      <MenuItem key={i} onClick={onClose}>{lang}</MenuItem>
    ))}
  </Menu>
);

export default LanguageMenu;
