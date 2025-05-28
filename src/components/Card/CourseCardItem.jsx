import React from "react";
import { Card, Typography, Button, CardContent } from "@mui/material";
import KeyboardArrowRightIcon from "@mui/icons-material/KeyboardArrowRight";
import SemiCircleProgressBar from "../../components/CircularProgressBar/SemiCircleProgressBar";

const CourseCardItem = ({ title, percentage, chartColors }) => {
  return (
    <Card sx={{
            borderRadius: 3, 
            boxShadow: 3,    
            height:{
                sm: 305,
                md: 280,
            },
            paddingBottom:{
                xs: 2,// varsayılan değer
                md: 6,
                lg: 2
            }
          }}
    >
      <CardContent>
        <Typography
          variant="subtitle1"
          component="div"
          sx={{ fontWeight: "bold", display: "flex", justifyContent: "space-between" }}
        >
          {title}
          <Button
            size="small"
            sx={{ fontWeight: "bold", textTransform: "none", fontSize: "15px" }}
            endIcon={<KeyboardArrowRightIcon sx={{ fontSize: "40px", fontWeight: "bold"}} />}
          >
            Detaya git
          </Button>
        </Typography>
        <Typography variant="body2" color="text.secondary">
          Kurs Tamamlama Yüzdesi
        </Typography>
      </CardContent>
      <div style={{ display: "flex", justifyContent: "center", padding: 20, paddingBottom:50}}>
        <SemiCircleProgressBar percentage={percentage} chartColors={chartColors} />
      </div>
    </Card>
  );
};

export default CourseCardItem;