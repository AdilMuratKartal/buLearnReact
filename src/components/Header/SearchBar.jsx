// components/Header/SearchBar.jsx
import React from 'react';
import { Autocomplete, IconButton, TextField, useMediaQuery } from '@mui/material';
import SearchIcon from '@mui/icons-material/Search';
import SearchOffIcon from '@mui/icons-material/SearchOff';
import { NAV_ITEMS } from './constants';

const SearchBar = ({ searching, setSearching, navIconColor }) => {
  const mdScreen = useMediaQuery("(max-width: 992px) and (min-width: 601px)");
  const smScreen = useMediaQuery("(max-width: 601px)");

  const width = !searching ? "0px" : mdScreen ? "18vw" : smScreen ? "60vw" : "10vw";

  return (
    <div className="search-container">
      <IconButton sx={{ color: navIconColor }} onClick={() => setSearching(prev => !prev)}>
        {searching ? <SearchOffIcon /> : <SearchIcon />}
      </IconButton>
      <Autocomplete
        freeSolo
        options={NAV_ITEMS.map(item => item.name)}
        popupIcon={null}
        clearIcon={null}
        sx={{
          width,
          transition: 'width 0.3s ease',
          ml: 1,
          '& .MuiInputBase-root': {
            color: navIconColor,
            px: 1,
          },
          '& .MuiInputBase-input::placeholder': {
            color: 'rgba(255,255,255,0.5)',
          }
        }}
        renderInput={(params) => (
          <TextField
            {...params}
            variant="standard"
            placeholder="Ara…"
            InputProps={{
              ...params.InputProps,
              disableUnderline: false,
              sx: {
                '&:before': { borderBottomColor: 'rgba(255,255,255,0.5)' },
                '&:hover:before': { borderBottomColor: '#fff' },
                '&:after': { borderBottomColor: navIconColor },
              }
            }}
          />
        )}
      />
    </div>
  );
};

export default SearchBar;
