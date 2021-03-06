--Twisted Vocaloid Nephilise's Shadow - Code D.E.S.T.R.O.Y. 01
function c66652245.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,66652246,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),1,true,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c66652245.sprcon)
	e2:SetOperation(c66652245.sprop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c66652245.immfilter)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c66652245.con)
	e4:SetOperation(c66652245.op)
	c:RegisterEffect(e4)
	--place pcard
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c66652245.pencon)
	e5:SetCost(c66652245.pencost)
	e5:SetTarget(c66652245.pentg)
	e5:SetOperation(c66652245.penop)
	c:RegisterEffect(e5)
	--cannot disable summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	c:RegisterEffect(e6)
end
function c66652245.spfilter1(c,tp,ft)
	if c:IsCode(66652246) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(nil,true) and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) then
			return Duel.IsExistingMatchingCard(c66652245.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
		else
			return Duel.IsExistingMatchingCard(c66652245.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end
function c66652245.spfilter2(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end
function c66652245.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c66652245.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,ft)
end
function c66652245.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66652245,0))
	local g1=Duel.SelectMatchingCard(tp,c66652245.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,ft)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c66652245.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66652245,1))
	if ft>0 or (tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then
		g2=g:Select(tp,1,10,nil)
	else
		g2=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		if g:GetCount()>1 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66652245,1))
			local g3=g:Select(tp,1,9,g2:GetFirst())
			g2:Merge(g3)
		end
	end
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	--atk mod
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(g1:GetCount()*1000)
	c:RegisterEffect(e1)
	--def mod
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetReset(RESET_EVENT+0xff0000)
	e2:SetValue(g1:GetCount()*1000)
	c:RegisterEffect(e2)
end
function c66652245.immfilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	if te:IsActiveType(TYPE_MONSTER) and (te:IsHasType(0x7e0) or te:IsHasProperty(EFFECT_FLAG_FIELD_ONLY) or te:IsHasProperty(EFFECT_FLAG_OWNER_RELATE)) then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	end
	return false
end
function c66652245.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c66652245.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c66652245.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c66652245.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c66652245.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c66652245.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function c66652245.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c66652245.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c66652245.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c66652245.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c66652245.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c66652245.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c66652245.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end