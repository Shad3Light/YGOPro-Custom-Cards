--Paintress Picassudu
function c160007993.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160007993.splimit)
	e2:SetCondition(c160007993.splimcon)
	c:RegisterEffect(e2)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160007993,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c160007993.target)
	e3:SetOperation(c160007993.operation)
	c:RegisterEffect(e3)
end
function c160007993.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160007993.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160007993.spfilter(c,e,tp)
	return c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160007993.desfilter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and not c:IsType(TYPE_PENDULUM) 
		and not c:IsType(TYPE_NORMAL) and c:IsDestructable()
end
function c160007993.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c160007993.desfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c160007993.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c160007993.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c160007993.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c160007993.operation(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local tc1=tg1:GetFirst()
	if tc1:IsRelateToEffect(e) and (tc1:IsSetCard(0xc50) or tc1:IsType(TYPE_NORMAL)) then
		Duel.SpecialSummon(tg1,0,tp,tp,false,false,POS_FACEUP)
	end
	if tg2:GetFirst():IsRelateToEffect(e) then
		Duel.Destroy(tg2,REASON_EFFECT)
	end
end
