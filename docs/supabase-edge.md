# Supabase edge function

there's another potential issue with your current implementation. The trigger is trying to call a Supabase Edge Function directly, which isn't the recommended approach. Instead, you should use Supabase's built-in RESTful API to trigger the function.
Here's an updated version of your trigger that uses the pg_net extension (which is usually already enabled) instead of the net extension:

```plsql
CREATE OR REPLACE FUNCTION public.recalculate_daily_goals()
RETURNS TRIGGER AS $$
DECLARE
  v_user_id TEXT;
  v_date DATE;
BEGIN
  IF TG_OP = 'DELETE' THEN
    v_user_id := OLD.userid;
    v_date := OLD.date::date;
  ELSE
    v_user_id := NEW.userid;
    v_date := NEW.date::date;
  END IF;

  PERFORM pg_notify('recalculate_daily_goals', json_build_object(
    'user_id', v_user_id,
    'date', v_date
  )::text);

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER recalculate_daily_goals_trigger
AFTER INSERT OR UPDATE OR DELETE ON food_entries
FOR EACH ROW EXECUTE FUNCTION public.recalculate_daily_goals();
```
This trigger uses pg_notify to send a notification when a food entry is inserted, updated, or deleted. You can then set up a listener in your Supabase Edge Function to handle these notifications and perform the recalculation.
Here's an example of how your Edge Function could listen for these notifications:

```typescript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  Deno.env.get('SUPABASE_STORAGE_URL') ?? ''
)

supabase
  .from('food_entries')
  .on('*', (payload) => {
    const { user_id, date } = payload.new || payload.old
    // Perform your recalculation logic here
    recalculateDailyGoals(user_id, date)
  })
  .subscribe()

async function recalculateDailyGoals(userId: string, date: string) {
  // Your recalculation logic here
}

Deno.serve(async (req) => {
  // This is just to keep the function running
  return new Response('OK', { status: 200 })
})
```
This approach is more efficient and doesn't require direct HTTP calls from within the database.
