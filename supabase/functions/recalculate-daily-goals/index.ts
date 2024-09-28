// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { userId, date } = await req.json()

    console.log(`Received request for userId: ${userId}, date: ${date}`)

    if (!userId || !date) {
      throw new Error('userId and date are required')
    }

    // Validate input
    if (typeof userId !== 'string') {
      throw new Error('Invalid userId: must be a string')
    }
    if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
      throw new Error('Invalid date format: must be YYYY-MM-DD')
    }

    // Fetch all food entries for the user on the given date
    const { data: foodEntries, error: foodEntriesError } = await supabase
      .from('food_entries')
      .select('*')
      .eq('userid', userId)
      .gte('date', `${date}T00:00:00`)
      .lt('date', `${date}T23:59:59`)

    if (foodEntriesError) throw foodEntriesError

    console.log(`Found ${foodEntries.length} food entries for the given date`)

    // Fetch the user's nutrition goals
    const { data: userProfiles, error: userProfileError } = await supabase
      .from('user_profiles')
      .select('nutritionGoals')
      .eq('id', userId)

    if (userProfileError) throw userProfileError

    if (!userProfiles || userProfiles.length === 0) {
      throw new Error(`User profile not found for userId: ${userId}`)
    }

    if (userProfiles.length > 1) {
      console.warn(`Multiple user profiles found for userId: ${userId}. Using the first one.`)
    }

    const userProfile = userProfiles[0]

    if (!userProfile || !userProfile.nutritionGoals) {
      throw new Error('User profile or nutrition goals not found')
    }

    // Calculate total nutrition from all food entries
    const totalNutrition = foodEntries.reduce((total, entry) => {
      if (entry.nutritionInfo && Array.isArray(entry.nutritionInfo.nutrition)) {
        entry.nutritionInfo.nutrition.forEach(item => {
          if (!total[item.component]) {
            total[item.component] = 0
          }
          total[item.component] += item.value
        })
      }
      return total
    }, {})

    console.log('Calculated total nutrition:', totalNutrition)

    // Update daily goals
    const updatedGoals = Object.entries(userProfile.nutritionGoals).reduce((goals, [key, value]) => {
      goals[key] = {
        ...value,
        actual: totalNutrition[key] || 0
      }
      return goals
    }, {})

    console.log('Updated goals:', updatedGoals)

    // Save updated daily goals
    const { error: updateError } = await supabase
      .from('daily_goals')
      .upsert({
        user_id: userId,
        date,
        goals: updatedGoals
      })

    if (updateError) throw updateError

    return new Response(
      JSON.stringify({ message: 'Daily goals recalculated successfully', updatedGoals }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error in recalculate-daily-goals function:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/recalculate-daily-goals' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
