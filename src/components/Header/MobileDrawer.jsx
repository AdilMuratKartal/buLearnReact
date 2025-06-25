// components/Header/MobileDrawer.jsx
import React from 'react';
import { Drawer, Button, Box } from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { NAV_ITEMS } from './constants';
import logoWhite from '../../assets/images/logo_beyaz.png';

const MobileDrawer = ({ open, toggleDrawer }) => {
  const navigate = useNavigate();

  return (
    <Drawer open={open} onClose={() => toggleDrawer(false)} anchor="left">
      <Box
        sx={{
          height: '100vh',
          textAlign: "center",
          backgroundColor: "black",
          width: {
            xs: '80vw',
            sm: '60vw',
            md: '40vw',
            lg: '30vw',
          },
        }}
      >
        <Button sx={{ width: "100%", height: "calc(100vh / 8)" }} onClick={() => navigate('/')}>
          <img className="logo-img" src={logoWhite} alt="BuLearn Logo" />
        </Button>
        {NAV_ITEMS.map((item, idx) => (
          <Button
            key={idx}
            onClick={() => {
              toggleDrawer(false);
              navigate(item.link);
            }}
            size="small"
            sx={{
              width: "100%",
              height: "calc(100vh / 8)",
              color: "#fff"
            }}
          >
            {item.name}
          </Button>
        ))}
      </Box>
    </Drawer>
  );
};

export default MobileDrawer;
