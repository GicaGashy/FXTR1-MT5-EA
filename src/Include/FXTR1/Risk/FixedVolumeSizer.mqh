#ifndef FXTR1_RISK_FIXEDVOLUMESIZER_MQH
#define FXTR1_RISK_FIXEDVOLUMESIZER_MQH

#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/PositionSizeResult.mqh>

class CFXTR1FixedVolumeSizer
{
public:
   CFXTR1PositionSizeResult Calculate(const CFXTR1RiskEvaluationRequest &request)
   {
      CFXTR1PositionSizeResult result;

      if(!request.HasValidMarket())
      {
         result.Fail("Invalid market snapshot.");
         return result;
      }

      if(!request.Market.HasValidVolumeConstraints())
      {
         result.Fail("Invalid volume constraint data.");
         return result;
      }

      double desired_volume = request.Settings.FixedVolume;
      if(desired_volume <= 0.0)
      {
         result.Fail("Fixed volume must be greater than zero.");
         return result;
      }

      if(desired_volume < request.Market.VolumeMin)
      {
         result.Fail("Fixed volume is below symbol minimum volume.");
         return result;
      }

      if(desired_volume > request.Market.VolumeMax)
      {
         result.Fail("Fixed volume is above symbol maximum volume.");
         return result;
      }

      double steps = MathRound((desired_volume - request.Market.VolumeMin) / request.Market.VolumeStep);
      double aligned_volume = request.Market.VolumeMin + steps * request.Market.VolumeStep;
      if(MathAbs(aligned_volume - desired_volume) > 0.0000001)
      {
         result.Fail("Fixed volume is not aligned to symbol volume step.");
         return result;
      }

      result.Pass(desired_volume, "Fixed volume is valid.");
      return result;
   }
};

#endif
