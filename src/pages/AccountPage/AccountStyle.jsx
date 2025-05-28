import styled from 'styled-components';
import Container from '@mui/material/Container';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import Grid from '@mui/material/Grid';
import Stack from '@mui/material/Grid';
import CardMedia from '@mui/material/CardMedia';
import { Card } from '@mui/material';

export const BoxFlex = styled(Box)`
    width : 100% !important;
    display: flex;
    justify-content: center;
    align-items: center;
`;

export const FullWidthBox = styled(Box)`
    width : 100% !important;
`

export const AccountButton = styled(Button)`
    text-transform: none !important;
    font-weight: bold !important;
`;

export const FullWidthStack = styled(Stack)`
    width: 100% !important;
`

export const CustomCardMedia = styled(CardMedia)`
    width: min-content !important;
`