--The Last Embraced Memory
function c68186168.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(68186168,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,68186168)
	e1:SetCondition(c68186168.condition)
	e1:SetTarget(c68186168.target)
	e1:SetOperation(c68186168.operation)
	c:RegisterEffect(e1)
end
function c68186168.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c68186168.filter1(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_DARK)
		and Duel.IsExistingTarget(c68186168.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel())
end
function c68186168.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c68186168.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c68186168.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c68186168.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c68186168.filter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c68186168.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c68186168.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c68186168.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c68186168.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,tc1:GetLevel()+tc2:GetLevel())
	if sg:GetCount()==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,1,1,nil)
	Duel.SpecialSummon(ssg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
end
