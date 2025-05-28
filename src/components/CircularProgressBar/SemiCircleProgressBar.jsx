import React from "react";
import {
  CircularProgressbarWithChildren,
  buildStyles,
} from "react-circular-progressbar";
import "react-circular-progressbar/dist/styles.css";

const SemiCircleProgressBar = ({ percentage, chartColors }) => {
  return (
    <div style={{ width: 150, height: 120, position: "relative"}}>
      {/* Yarım daire */}
      <div style={{ transform: "rotate(180deg)", overflow: "hidden" }}>
        <CircularProgressbarWithChildren
          value={percentage}    
          maxValue={100}
          circleRatio={0.75}
          strokeWidth={12}
          styles={buildStyles({
            rotation: 1.13,  // çemberin başlangıç açısı (360° * 0.625 = 225°)
            pathColor: chartColors,
            trailColor: "#f0f0f0",
            strokeLinecap: "butt",
            pathTransitionDuration: 0.8,
          })}
        >
            {/* Dış iç-halka Gri olan*/}
            <div
            style={{
                width: "60%",
                height: "60%",
                borderRadius: "50%",
                backgroundColor: "#f0f0f0",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                transform: "rotate(180deg)",
                boxShadow: "rgba(67, 71, 85, 0.27) 0px 0px 0.25em, rgba(90, 125, 188, 0.05) 0px 0.25em 1em",
            }}
            >
                {/* İç iç-halka Beyaz olan */}
                <div
                    style={{
                    width: "90%",
                    height: "90%",
                    borderRadius: "50%",
                    backgroundColor: "#fff",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                    boxShadow: `
                        rgba(67, 71, 85, 0.27) 0px 0px 0.5em 0.3em,
                        rgba(90, 125, 188, 0.05) 0px 0.8em 2em 0,
                        rgba(67, 71, 85, 0.15) 0px 0px 1em 0.5em
                    `,
                    }}
                >
                    <span style={{ fontSize: 30, fontWeight: "bold", color: chartColors }}>
                    %{percentage}
                    </span>
                </div>
            </div>
        </CircularProgressbarWithChildren>
      </div>

      {/* Alt 0 ve 100 */}
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          gap: 50,
          position: "absolute",
          bottom: -20,
          width: "100%",
          left: -6,
          padding: "0 5px",
          fontSize: 12,
          color: "#444",
        }}
      >
        <span>0</span>
        <span>100</span>
      </div>
    </div>
  );
};

export default SemiCircleProgressBar;
