--Diabearical Lilith
--Scripted by Yoshi Duels
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Summon procedure
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,160428042,160428037)
	--Return 1 monster to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP_ATTACK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	--effect
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	g=g:AddMaximumCheck()
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(s.spfilter,1-tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and #sg>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(tg,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end