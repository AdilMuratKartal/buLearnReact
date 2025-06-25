// components/Header/UserMenu.jsx
import React from 'react';
import { Menu, MenuItem } from '@mui/material';

const UserMenu = ({ anchorEl, open, onClose, onAccount, onLogOut }) => (
  <Menu anchorEl={anchorEl} open={open} onClose={onClose}>
    <MenuItem onClick={onClose}>Profil</MenuItem>
    <MenuItem onClick={onAccount}>Hesabım</MenuItem>
    <MenuItem onClick={onLogOut}>Çıkış Yap</MenuItem>
  </Menu>
);

export default UserMenu;
