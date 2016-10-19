--Mystic Acrylic
function c500319545.initial_effect(c)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500319545,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(c500319545.sumcon)
	e2:SetTarget(c500319545.sumtg)
	e2:SetOperation(c500319545.sumop)
	e2:SetLabelObject(e2)
	c:RegisterEffect(e2)
end
function c500319545.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetReasonCard()
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
	e1:SetValue(0)
	tc:RegisterEffect(e1)
end
function c500319545.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetAttackTarget()==nil
end
function c500319545.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,57139546,0,0x4011,-2,-2,4,RACE_AQUA,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c500319545.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,500319546,0,0x4011,-2,-2,4,RACE_AQUA,ATTRIBUTE_LIGHT) then return end
		for i=1,2 do
			local token=Duel.CreateToken(tp,500319545+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UNRELEASABLE_SUM)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(1)
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_DESTROY)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetOperation(c500319545.desop)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e3,true)
		end
		Duel.SpecialSummonComplete()
	end
end
