--Paintress Goghi
function c160007854.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160007854.splimit)
	e2:SetCondition(c160007854.splimcon)
	c:RegisterEffect(e2)
	--gain atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c160007854.efilter)
	e3:SetValue(300)
	c:RegisterEffect(e3)
end
function c160007854.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160007854.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160007854.efilter(e,c)
	return c:IsType(TYPE_NORMAL) or c:IsSetCard(0xc50)
end
